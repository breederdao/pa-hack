/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        'courier': ['Courier Prime'],
      },
      colors: {
        'dusty-orange': '#ED863A',
        rust: '#C44F19',
        night: '#140803',
        cedar: '#39190F',
        walnut: '#763F22',
      }
    },
  },
  plugins: [],
}

