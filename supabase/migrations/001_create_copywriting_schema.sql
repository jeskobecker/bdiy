/*
  # Copywriting Tool Database Schema

  1. New Tables
    - `copywriting_projects`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to auth.users)
      - `title` (text) - Project name
      - `type` (text) - Type: 'book', 'sales-letter', 'vsl', 'landing-page', 'ad', 'email'
      - `status` (text) - Status: 'draft', 'in-progress', 'completed'
      - `description` (text) - Project description
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

    - `copywriting_assets`
      - `id` (uuid, primary key)
      - `project_id` (uuid, foreign key to copywriting_projects)
      - `title` (text) - Asset title
      - `content` (text) - The actual copy content
      - `file_type` (text) - File extension: 'md', 'html', 'txt'
      - `file_path` (text) - Relative path like '/chapters/chapter-01.md'
      - `version` (integer) - Version number for tracking changes
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)

    - `target_audiences`
      - `id` (uuid, primary key)
      - `project_id` (uuid, foreign key to copywriting_projects)
      - `name` (text) - Audience segment name
      - `demographics` (jsonb) - Age, gender, location, etc.
      - `pain_points` (text[]) - Array of pain points
      - `desires` (text[]) - Array of desires/goals
      - `objections` (text[]) - Common objections
      - `created_at` (timestamptz)

    - `products`
      - `id` (uuid, primary key)
      - `project_id` (uuid, foreign key to copywriting_projects)
      - `name` (text) - Product/service name
      - `description` (text)
      - `price` (numeric) - Price
      - `features` (jsonb) - Product features
      - `benefits` (text[]) - Key benefits
      - `usp` (text) - Unique Selling Proposition
      - `created_at` (timestamptz)

    - `copywriting_templates`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to auth.users)
      - `name` (text) - Template name
      - `type` (text) - Template type
      - `content` (text) - Template content with placeholders
      - `is_public` (boolean) - Whether template is shared
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to manage their own data
    - Restrict access based on user_id and project ownership
*/

-- Create copywriting_projects table
CREATE TABLE IF NOT EXISTS copywriting_projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  type text NOT NULL CHECK (type IN ('book', 'sales-letter', 'vsl', 'landing-page', 'ad', 'email', 'product-description')),
  status text DEFAULT 'draft' CHECK (status IN ('draft', 'in-progress', 'completed', 'archived')),
  description text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create copywriting_assets table
CREATE TABLE IF NOT EXISTS copywriting_assets (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES copywriting_projects(id) ON DELETE CASCADE NOT NULL,
  title text NOT NULL,
  content text DEFAULT '',
  file_type text NOT NULL CHECK (file_type IN ('md', 'html', 'txt', 'json')),
  file_path text NOT NULL,
  version integer DEFAULT 1,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Create target_audiences table
CREATE TABLE IF NOT EXISTS target_audiences (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES copywriting_projects(id) ON DELETE CASCADE NOT NULL,
  name text NOT NULL,
  demographics jsonb DEFAULT '{}',
  pain_points text[] DEFAULT ARRAY[]::text[],
  desires text[] DEFAULT ARRAY[]::text[],
  objections text[] DEFAULT ARRAY[]::text[],
  created_at timestamptz DEFAULT now()
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid REFERENCES copywriting_projects(id) ON DELETE CASCADE NOT NULL,
  name text NOT NULL,
  description text DEFAULT '',
  price numeric DEFAULT 0,
  features jsonb DEFAULT '[]',
  benefits text[] DEFAULT ARRAY[]::text[],
  usp text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

-- Create copywriting_templates table
CREATE TABLE IF NOT EXISTS copywriting_templates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  name text NOT NULL,
  type text NOT NULL,
  content text NOT NULL,
  is_public boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE copywriting_projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE copywriting_assets ENABLE ROW LEVEL SECURITY;
ALTER TABLE target_audiences ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE copywriting_templates ENABLE ROW LEVEL SECURITY;

-- Policies for copywriting_projects
CREATE POLICY "Users can view own projects"
  ON copywriting_projects FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own projects"
  ON copywriting_projects FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own projects"
  ON copywriting_projects FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own projects"
  ON copywriting_projects FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Policies for copywriting_assets
CREATE POLICY "Users can view assets of own projects"
  ON copywriting_assets FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = copywriting_assets.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create assets in own projects"
  ON copywriting_assets FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = copywriting_assets.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update assets in own projects"
  ON copywriting_assets FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = copywriting_assets.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = copywriting_assets.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete assets in own projects"
  ON copywriting_assets FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = copywriting_assets.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  );

-- Policies for target_audiences (same pattern as assets)
CREATE POLICY "Users can view audiences of own projects"
  ON target_audiences FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = target_audiences.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage audiences in own projects"
  ON target_audiences FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = target_audiences.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = target_audiences.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  );

-- Policies for products (same pattern)
CREATE POLICY "Users can view products of own projects"
  ON products FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = products.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can manage products in own projects"
  ON products FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = products.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM copywriting_projects
      WHERE copywriting_projects.id = products.project_id
      AND copywriting_projects.user_id = auth.uid()
    )
  );

-- Policies for copywriting_templates
CREATE POLICY "Users can view own and public templates"
  ON copywriting_templates FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id OR is_public = true);

CREATE POLICY "Users can create own templates"
  ON copywriting_templates FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own templates"
  ON copywriting_templates FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own templates"
  ON copywriting_templates FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_projects_user_id ON copywriting_projects(user_id);
CREATE INDEX IF NOT EXISTS idx_projects_type ON copywriting_projects(type);
CREATE INDEX IF NOT EXISTS idx_projects_status ON copywriting_projects(status);
CREATE INDEX IF NOT EXISTS idx_assets_project_id ON copywriting_assets(project_id);
CREATE INDEX IF NOT EXISTS idx_audiences_project_id ON target_audiences(project_id);
CREATE INDEX IF NOT EXISTS idx_products_project_id ON products(project_id);
CREATE INDEX IF NOT EXISTS idx_templates_user_id ON copywriting_templates(user_id);
CREATE INDEX IF NOT EXISTS idx_templates_public ON copywriting_templates(is_public);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for updated_at
CREATE TRIGGER update_projects_updated_at
  BEFORE UPDATE ON copywriting_projects
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_assets_updated_at
  BEFORE UPDATE ON copywriting_assets
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();
