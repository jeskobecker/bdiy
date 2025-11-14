import { LLMManager } from '~/lib/modules/llm/manager';
import type { Template } from '~/types/template';

export const WORK_DIR_NAME = 'project';
export const WORK_DIR = `/home/${WORK_DIR_NAME}`;
export const MODIFICATIONS_TAG_NAME = 'bolt_file_modifications';
export const MODEL_REGEX = /^\[Model: (.*?)\]\n\n/;
export const PROVIDER_REGEX = /\[Provider: (.*?)\]\n\n/;
export const DEFAULT_MODEL = 'claude-3-5-sonnet-latest';
export const PROMPT_COOKIE_KEY = 'cachedPrompt';
export const TOOL_EXECUTION_APPROVAL = {
  APPROVE: 'Yes, approved.',
  REJECT: 'No, rejected.',
} as const;
export const TOOL_NO_EXECUTE_FUNCTION = 'Error: No execute function found on tool';
export const TOOL_EXECUTION_DENIED = 'Error: User denied access to tool execution';
export const TOOL_EXECUTION_ERROR = 'Error: An error occured while calling tool';

const llmManager = LLMManager.getInstance(import.meta.env);

export const PROVIDER_LIST = llmManager.getAllProviders();
export const DEFAULT_PROVIDER = llmManager.getDefaultProvider();

export const providerBaseUrlEnvKeys: Record<string, { baseUrlKey?: string; apiTokenKey?: string }> = {};
PROVIDER_LIST.forEach((provider) => {
  providerBaseUrlEnvKeys[provider.name] = {
    baseUrlKey: provider.config.baseUrlKey,
    apiTokenKey: provider.config.apiTokenKey,
  };
});

// Copywriting Templates

export const STARTER_TEMPLATES: Template[] = [
  {
    name: 'Long-Form Sales Letter',
    label: 'Sales Letter - Long Form',
    description: 'Klassischer Long-Form Sales Letter mit AIDA-Framework und Storytelling',
    githubRepo: '',
    tags: ['sales-letter', 'long-form', 'conversion', 'aida'],
    icon: 'i-ph:file-text',
  },
  {
    name: 'Short-Form Sales Letter',
    label: 'Sales Letter - Short Form',
    description: 'Kompakter Sales Letter für schnelle Conversion-Entscheidungen',
    githubRepo: '',
    tags: ['sales-letter', 'short-form', 'conversion'],
    icon: 'i-ph:file-text',
  },
  {
    name: 'VSL Script - PAS',
    label: 'Video Sales Letter Script',
    description: 'VSL-Script mit Problem-Agitate-Solution Framework und Timecodes',
    githubRepo: '',
    tags: ['vsl', 'video', 'script', 'pas-framework'],
    icon: 'i-ph:video',
  },
  {
    name: 'Landing Page - Lead Gen',
    label: 'Landing Page für Lead-Generierung',
    description: 'Conversion-optimierte Landing Page für E-Mail-Sammlung und Lead-Magnets',
    githubRepo: '',
    tags: ['landing-page', 'lead-generation', 'conversion'],
    icon: 'i-ph:desktop',
  },
  {
    name: 'Landing Page - Webinar',
    label: 'Webinar-Anmeldeseite',
    description: 'Landing Page speziell für Webinar-Registrierungen mit Countdown',
    githubRepo: '',
    tags: ['landing-page', 'webinar', 'registration'],
    icon: 'i-ph:presentation',
  },
  {
    name: 'E-Book Chapter',
    label: 'Buchkapitel (Ratgeber)',
    description: 'Strukturiertes Buchkapitel mit Einleitung, Hauptteil und Zusammenfassung',
    githubRepo: '',
    tags: ['book', 'e-book', 'chapter', 'ratgeber'],
    icon: 'i-ph:book',
  },
  {
    name: 'Email Sequence',
    label: 'E-Mail-Sequenz',
    description: '5-teilige E-Mail-Sequenz für Produktlaunch oder Nurturing',
    githubRepo: '',
    tags: ['email', 'sequence', 'nurture', 'launch'],
    icon: 'i-ph:envelope',
  },
  {
    name: 'Facebook Ad Copy',
    label: 'Facebook/Instagram Ads',
    description: 'Social Media Ad-Copy mit Hook, Benefit und CTA',
    githubRepo: '',
    tags: ['ads', 'facebook', 'instagram', 'social-media'],
    icon: 'i-ph:megaphone',
  },
  {
    name: 'Google Ads Copy',
    label: 'Google Ads',
    description: 'Suchmaschinen-Anzeigen mit optimierten Headlines und Descriptions',
    githubRepo: '',
    tags: ['ads', 'google', 'search', 'ppc'],
    icon: 'i-ph:magnifying-glass',
  },
  {
    name: 'Product Description',
    label: 'Produktbeschreibung',
    description: 'Benefit-fokussierte Produktbeschreibung für E-Commerce',
    githubRepo: '',
    tags: ['product', 'e-commerce', 'description'],
    icon: 'i-ph:shopping-cart',
  },
];
