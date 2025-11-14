import React from 'react';
import type { Template } from '~/types/template';
import { STARTER_TEMPLATES } from '~/utils/constants';

interface TemplateCardProps {
  template: Template;
}

const TemplateCard: React.FC<TemplateCardProps> = ({ template }) => (
  <div
    className="flex flex-col items-center gap-2 p-4 border border-bolt-elements-borderColor rounded-lg hover:border-bolt-elements-borderColorActive hover:bg-bolt-elements-background-depth-2 transition-all cursor-pointer group"
    title={template.description}
  >
    <div
      className={`${template.icon} w-12 h-12 text-5xl text-bolt-elements-textSecondary group-hover:text-bolt-elements-textPrimary transition-colors`}
    />
    <span className="text-xs text-center text-bolt-elements-textSecondary group-hover:text-bolt-elements-textPrimary font-medium">
      {template.label}
    </span>
  </div>
);

const StarterTemplates: React.FC = () => {
  return (
    <div className="flex flex-col items-center gap-6">
      <span className="text-sm text-bolt-elements-textSecondary">oder wähle eine Copywriting-Vorlage</span>
      <div className="flex justify-center">
        <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4 max-w-4xl">
          {STARTER_TEMPLATES.map((template) => (
            <TemplateCard key={template.name} template={template} />
          ))}
        </div>
      </div>
    </div>
  );
};

export default StarterTemplates;
