# CozyKnots — Premium Handmade Crochet E-Commerce Store

CozyKnots is a production-ready, highly responsive, and premium e-commerce web application built for an artisanal handmade crochet business. Crafted with React 18, Vite, Zustand, Tailwind CSS, and Firebase.

## Technology Stack

- **Frontend**: React 18, Vite, React Router v6, Tailwind CSS, Framer Motion
- **State Management**: Zustand
- **Backend Services**: Firebase v9 SDK (Authentication, Firestore, Storage)
- **Forms**: React Hook Form & Zod Validation
- **Localisation**: react-i18next (supports English & Spanish)
- **Payments Integration**: Stripe (Elements & card integrations)

## Features (Phase 1)
- Custom design system matching CozyKnots brand colors, layout grids, typography, and warm soft shadows.
- Multi-currency conversion (USD, EUR, GBP, INR) with automatic initial rate syncing.
- Multi-language localization toggling (English & Spanish).
- Class-based dark mode, persisted in local storage.
- Interactive slide-in Cart drawer with quantity updates, coupon application, and subtotaling.
- Horizontal featured product carousel, product best-sellers, new arrivals, meeting the artisan section, Instagram feed grid, and newsletter subscription form connected to Cloud Firestore.
- Fixed WhatsApp floating action button with pulsing micro-interaction.

---

## Deploying to Netlify from GitHub

Follow these steps to deploy the CozyKnots storefront to Netlify:

### Step 1: Push Project to GitHub
1. Create a new repository on your GitHub account.
2. Open terminal in the project folder and run:
   ```bash
   git init
   git add .
   git commit -m "Initial commit of CozyKnots Phase 1"
   git branch -M main
   git remote add origin https://github.com/your-username/cozyknots.git
   git push -u origin main
   ```

### Step 2: Connect to Netlify
1. Log in to your [Netlify Console](https://app.netlify.com/).
2. Click **Add new site** > **Import an existing project**.
3. Choose **GitHub** as your provider and authorize Netlify.
4. Select the `cozyknots` repository from your list.

### Step 3: Configure Build Settings
Netlify will automatically detect configuration files, but verify these match:
- **Build command**: `npm run build`
- **Publish directory**: `dist`

### Step 4: Setup Environment Variables
Under **Site Configuration** > **Environment variables** > **Add a variable**, add the keys defined in `.env.example`:
1. `VITE_FIREBASE_API_KEY`
2. `VITE_FIREBASE_AUTH_DOMAIN`
3. `VITE_FIREBASE_PROJECT_ID`
4. `VITE_FIREBASE_STORAGE_BUCKET`
5. `VITE_FIREBASE_MESSAGING_SENDER_ID`
6. `VITE_FIREBASE_APP_ID`
7. `VITE_STRIPE_PUBLISHABLE_KEY`
8. `VITE_EXCHANGERATE_API_KEY` (Optional)

### Step 5: Deploy
Click **Deploy site**. Netlify will build the application, generate the sitemap, copy static assets, and assign a live URL. The client-side routing is handled safely due to configurations in `netlify.toml`.
