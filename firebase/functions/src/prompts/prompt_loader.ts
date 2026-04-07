import * as fs from 'fs';
import * as path from 'path';

const PROMPTS_DIR = path.join(__dirname, '../../prompts');

/**
 * Loads a prompt file by name (without .md extension).
 * Throws if the file doesn't exist — fail loudly on misconfiguration.
 */
export function loadPrompt(name: string): string {
  const filePath = path.join(PROMPTS_DIR, `${name}.md`);
  if (!fs.existsSync(filePath)) {
    throw new Error(`Prompt file not found: ${filePath}`);
  }
  return fs.readFileSync(filePath, 'utf-8');
}

/**
 * Fills in prompt template variables.
 * Variables are in the format {{VARIABLE_NAME}}.
 */
export function fillPrompt(
  template: string,
  variables: Record<string, string>
): string {
  let result = template;
  for (const [key, value] of Object.entries(variables)) {
    result = result.replaceAll(`{{${key}}}`, value);
  }
  return result;
}
