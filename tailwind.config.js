/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        cream: '#FAF7F2',
        ivory: '#F3EDE3',
        beige: '#E2D5C3',
        blush: {
          DEFAULT: '#F2C4CE',
          deep: '#D4849A',
        },
        sage: {
          DEFAULT: '#9DB89D',
          deep: '#6E9470',
        },
        brown: {
          DEFAULT: '#8B6E52',
          soft: '#A68B6F',
        },
        charcoal: '#3D3028',
        // Dark mode custom variables mapping
        darkBg: '#1C1612',
        darkSurface: '#251E18',
        darkText: '#EDE0D4',
      },
      fontFamily: {
        serif: ['"Playfair Display"', 'serif'],
        sans: ['"DM Sans"', 'sans-serif'],
      },
      boxShadow: {
        warm: '0 4px 24px rgba(139, 110, 82, 0.08)',
        'warm-hover': '0 8px 32px rgba(139, 110, 82, 0.16)',
      },
      borderRadius: {
        '2xl': '16px',
      },
    },
  },
  plugins: [],
}
