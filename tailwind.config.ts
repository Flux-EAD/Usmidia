import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "./content/**/*.{ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        ink: "#000000",
        paper: "#ffffff",
        // acento da área FILMES — azul institucional US Mídia
        filmes: "#0041ff",
        // acento da área US mid.ia — osso, quente, para contrastar com o azul
        midia: "#e9e3d7",
        smoke: "#0b0b0b",
        ash: "#161616",
      },
      fontFamily: {
        counter: ['"New Black Typeface"', "ui-sans-serif", "sans-serif"],
        sans: [
          '"New Black Typeface"',
          "ui-sans-serif",
          "system-ui",
          "-apple-system",
          "Segoe UI",
          "Inter",
          "Helvetica Neue",
          "Arial",
          "sans-serif",
        ],
      },
      letterSpacing: {
        tightest: "-0.045em",
      },
      maxWidth: {
        site: "1440px",
      },
    },
  },
  plugins: [],
};

export default config;
