# CraftyBay

A mobile e-commerce app built with **Flutter**. Browse products by category and brand, search, read and write reviews, keep a wish list, manage a cart, and sign up with email OTP verification.

> Built as an assignment project for the [Ostad](https://ostad.app) Flutter course. The task was to build a complete shopping app against the course's REST API (the `simple-ecommerce` Postman collection).

## Screenshots

| Splash | Login | Sign up | OTP |
|:---:|:---:|:---:|:---:|
| ![Splash](docs/screenshots/01-splash.png) | ![Login](docs/screenshots/02-login.png) | ![Sign up](docs/screenshots/03-signup.png) | ![OTP](docs/screenshots/04-otp.png) |

| Home | Categories | Product list | Search |
|:---:|:---:|:---:|:---:|
| ![Home](docs/screenshots/05-home.png) | ![Categories](docs/screenshots/06-categories.png) | ![Product list](docs/screenshots/07-product-list.png) | ![Search](docs/screenshots/08-search.png) |

| Product details | Reviews | Create review | Cart |
|:---:|:---:|:---:|:---:|
| ![Product details](docs/screenshots/09-product-details.png) | ![Reviews](docs/screenshots/10-reviews.png) | ![Create review](docs/screenshots/11-create-review.png) | ![Cart](docs/screenshots/12-cart.png) |

| Wish list | Profile |
|:---:|:---:|
| ![Wish list](docs/screenshots/13-wishlist.png) | ![Profile](docs/screenshots/14-profile.png) |

## Features

- **Authentication:** sign up, email OTP verification, login, complete profile. A saved token keeps you signed in, and an expired session sends you back to login.
- **Home:** banner carousel, categories, brands, products, and a **Popular** row ranked by customer reviews.
- **Browse:** category and brand pages, and product lists that load more as you scroll.
- **Search:** find products by name.
- **Product details:** photo carousel, color and size pickers, quantity, description, rating.
- **Reviews:** read reviews with star ratings and write your own.
- **Cart:** add items, change quantity, remove items, see the running total.
- **Wish list:** heart any product from any screen, with a confirmation before removing and a snackbar after each change.
- **Profile:** view and edit your details.
- Loading spinners, error messages with **Retry**, and image placeholders.

### Not included

Checkout and orders. The cart's **Checkout** button is a placeholder, so the app stops before placing an order.

## Tech stack

| | |
|---|---|
| Framework | Flutter (Dart) |
| State management | [`provider`](https://pub.dev/packages/provider) (`ChangeNotifier`) |
| Networking | [`http`](https://pub.dev/packages/http) behind one `NetworkCaller` class |
| Local storage | `shared_preferences` (login token) |
| Config | `flutter_dotenv` (`.env`) |
| UI | Material 3, `google_fonts` (Poppins), `flutter_svg` |
| Logging | `logger` (debug builds only) |

## Project structure

```
lib/
├── app/            App widget, theme, and the list of providers
├── core/           Colors, strings, asset paths, API endpoints, navigator key
├── data/
│   ├── model/      JSON -> object classes
│   └── service/    One service per API area, plus network/ and cache/
├── domain/
│   └── entities/   Plain objects the UI works with (Product, CartItem, ...)
└── presentation/
    ├── core/       Shared widgets (product card, grid, dialogs, paging)
    └── feature/    One folder per screen group: auth, home, cart, ...
                    each with provider/ (state), view/ (pages), widgets/
```

A few design choices:

- **Layers:** the UI talks to providers, providers talk to services, and only `NetworkCaller` touches the `http` package.
- **Pagination:** `PagedProvider` is a reusable base class, so every long list loads page by page the same way.
- **Errors:** the API's `{"msg": "..."}` errors are shown as readable messages.
- **Auth:** the API expects the JWT in a `token` header, not `Authorization: Bearer`. A 401 on any signed-in request clears the token and opens the login page.

## Getting started

**Requirements:** [Flutter](https://docs.flutter.dev/get-started/install) (stable) and an Android device or emulator.

```bash
git clone https://github.com/RahatAlamgir/crafty_bay.git
cd crafty_bay
cp .env.example .env      # on Windows PowerShell: Copy-Item .env.example .env
flutter pub get
flutter run
```

Open `.env` and set `BASE_URL` to the API address from the course's `simple-ecommerce` Postman collection (the `BASE` variable). The app will not start without it.

```
BASE_URL=<your API base url>
```

> The API is hosted on a free tier, so the **first request after a quiet period can take 30 to 60 seconds** while the server wakes up. If the home screen keeps loading, wait a minute and reopen the app.

### Build an APK

```bash
flutter build apk --release
```

The file is created at `build/app/outputs/flutter-apk/app-release.apk`. Ready-made APKs are on the [Releases](https://github.com/RahatAlamgir/crafty_bay/releases) page.

## API

The app uses the customer endpoints of the course API: auth, brands, categories, products, reviews, cart, wishlist and slides. Admin-only routes are not used.

### Known limitations

- The API ignores the `product` filter on `/reviews`, so the app downloads all reviews once, shares them between screens, and filters on the device. This is fine for a small shop. A larger one would need the backend to filter by product.
- Search runs on the phone, because the API has no text search.
- Orders and checkout are not built yet.

## Author

**Rahat Alamgir** · [GitHub](https://github.com/RahatAlamgir)
