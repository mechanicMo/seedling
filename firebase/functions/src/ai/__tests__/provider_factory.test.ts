import { getProviderForTier } from '../provider_factory.js';
import { GroqProvider } from '../groq_provider.js';
import { AnthropicProvider } from '../anthropic_provider.js';

jest.mock('../groq_provider.js', () => ({
  GroqProvider: jest.fn().mockImplementation(() => ({})),
}));
jest.mock('../anthropic_provider.js', () => ({
  AnthropicProvider: jest.fn().mockImplementation(() => ({})),
}));

describe('getProviderForTier', () => {
  it('returns GroqProvider for free tier', () => {
    const provider = getProviderForTier('free', {
      groqApiKey: 'groq-key',
      anthropicApiKey: 'anthropic-key',
    });
    expect(GroqProvider).toHaveBeenCalledWith('groq-key');
    expect(provider).toBeDefined();
  });

  it('returns AnthropicProvider for paid tier', () => {
    const provider = getProviderForTier('paid', {
      groqApiKey: 'groq-key',
      anthropicApiKey: 'anthropic-key',
    });
    expect(AnthropicProvider).toHaveBeenCalledWith('anthropic-key');
    expect(provider).toBeDefined();
  });

  it('defaults to GroqProvider for unknown tier', () => {
    const provider = getProviderForTier('unknown', {
      groqApiKey: 'groq-key',
      anthropicApiKey: 'anthropic-key',
    });
    expect(GroqProvider).toHaveBeenCalledWith('groq-key');
    expect(provider).toBeDefined();
  });
});
