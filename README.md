# Jai Restaurant — Website

A single-file, production-ready website for Jai Restaurant (Company Bagh, Rohtak), with a Supabase-backed table booking form and WhatsApp integration.

## Files

- `index.html` — the whole website (HTML + CSS + JS in one file). Open it directly in a browser, or deploy it as-is.
- `supabase-schema.sql` — SQL to create the `table_bookings` table and Row Level Security policies in Supabase.

## 1. Set up Supabase (2 minutes)

1. Create a free project at [supabase.com](https://supabase.com).
2. Open **SQL Editor → New query**, paste the contents of `supabase-schema.sql`, and click **Run**.
3. Go to **Project Settings → API** and copy:
   - **Project URL**
   - **anon public** key (this one is safe to use in frontend code — never use the `service_role` key here)
4. Open `index.html`, find this block near the bottom, and paste your values in:
   ```js
   const SUPABASE_URL = "https://YOUR-PROJECT-REF.supabase.co";
   const SUPABASE_ANON_KEY = "YOUR-PUBLIC-ANON-KEY";
   ```

Until you do this, the booking form still works end-to-end (validation → WhatsApp), it just skips saving to the database and logs a warning in the browser console.

## 2. Deploy

`index.html` has no build step — any static host works:

- **Netlify / Vercel**: drag-and-drop the folder, or connect a Git repo.
- **Cloudflare Pages**: same — no build command needed, "publish directory" = this folder.
- **GitHub Pages**: push the folder to a repo and enable Pages.

## 3. Things to replace before going live

Everything below is a clearly-marked placeholder — nothing here was invented as fact:

- **Menu items, descriptions, prices, photos** — in the `MENU_ITEMS` array inside `index.html`. Each card is tagged "Sample item" in the UI as a reminder.
- **Opening hours** — in the Contact section (`Mon–Fri`, `Sat–Sun` rows), marked "placeholder — to confirm".
- **About section copy** — currently generic; add real history/story once available.
- **Food photography** — currently stock photos from Unsplash; swap for real photos of the restaurant and dishes.
- **Social links** — Instagram/Facebook icons in the footer are placeholders (`href="#"`).

## 4. What's already wired up

- Sticky nav with mobile hamburger menu, smooth-scroll anchor links.
- Menu section with **All / Starters / Main Course** filtering.
- Table booking form with inline validation (name, Indian mobile number, optional email, no past dates, guest count, 500-char note limit), a loading state, duplicate-submit prevention, and a confirmation screen.
- On successful submission: saves to Supabase `table_bookings` (status defaults to `pending`), then opens WhatsApp with a pre-filled (not auto-sent) message — the customer still taps **Send** in WhatsApp, which the UI is explicit about.
- Floating WhatsApp button + Call Now / WhatsApp / Get Directions buttons in Contact.
- Embedded Google Map for Company Bagh, Rohtak.
- Basic SEO: title, meta description, Open Graph tags, and Restaurant structured data (schema.org) using only the address/phone provided — no invented awards, reviews, or history.
- Accessible focus states and `prefers-reduced-motion` support.

## 5. Later: admin dashboard

The `table_bookings` table (see `supabase-schema.sql`) already has the fields an admin view would need — `status`, `booking_date`, contact details — plus indexes on `booking_date` and `status`. When you're ready to build one, add a Supabase Auth-gated policy for an `authenticated`/`admin` role (a starter policy is commented in the SQL file) rather than exposing the table publicly.
