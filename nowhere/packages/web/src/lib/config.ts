/**
 * The origin of the renderer site used for share links and QR codes.
 * Override at build time with the PUBLIC_SITE_ORIGIN environment variable.
 */
export const RENDERER_ORIGIN: string =
	(import.meta as any).env?.PUBLIC_SITE_ORIGIN || 'https://nowhr.xyz';

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
