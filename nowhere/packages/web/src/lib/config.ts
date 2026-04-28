/**
 * The origin of the renderer site used for share links and QR codes.
 *
 * Resolution order:
 *   1. PUBLIC_SITE_ORIGIN env var (build-time override)
 *   2. window.location.origin   (runtime — works on any domain automatically)
 *   3. 'https://nowhr.xyz'      (SSR / non-browser fallback)
 */
export const RENDERER_ORIGIN: string =
	(import.meta as any).env?.PUBLIC_SITE_ORIGIN ||
	(typeof window !== 'undefined' ? window.location.origin : 'https://nowhr.xyz');

/**
 * The hostname portion of RENDERER_ORIGIN (e.g. "nowhr.xyz").
 * Used for instance-detection checks (show "via <host>" when the current
 * hostname differs from the canonical one).
 */
export const SITE_HOSTNAME: string = (() => {
	try {
		return new URL(RENDERER_ORIGIN).hostname;
	} catch {
		return 'nowhr.xyz';
	}
})();
