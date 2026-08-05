// scripts/sellPagesData.mjs
// One entry per page. Add 2-3 per day per STRATEGY.md, then run:
//   node scripts/generate-sell-pages.mjs
// This writes/overwrites public/sell-my-{slug}.html for every entry below.

export const sellPages = [
  {
    slug: "sell-my-toyota-camry",
    make: "Toyota",
    model: "Camry",
    yearRange: "2017–2019",
    intro:
      "Toyota Camrys in the 6–8 year range hold value better than almost anything else on the road, " +
      "which cuts both ways for sellers: dealers want them, but private buyers often lowball on the " +
      "assumption a Camry \u2018should\u2019 be cheap. Franchised dealers bidding on your Camry know exactly " +
      "what reliability reputation is worth at auction \u2014 that\u2019s the gap PrivaBuy closes.",
    dealerWantsNote: "Dealers pay a premium for Camrys with full service records and SE/XSE trims over base LE.",
    valueRanges: [
      { band: "80k\u2013100k mi, LE/SE", note: "steady demand, fastest to sell for dealers" },
      { band: "100k\u2013130k mi, any trim", note: "still competitive vs. private-party due to reliability halo" },
    ],
    faqs: [
      { q: "Do dealers still want a high-mileage Camry?", a: "Yes \u2014 Camrys are one of the few models where 120k+ miles doesn\u2019t tank dealer interest, since the reliability reputation holds resale value on the lot." },
      { q: "Does trim level matter for a Camry sale?", a: "SE and XSE trims typically draw more competitive bids than base LE, but all trims get dealer interest given Camry\u2019s turnover speed." },
      { q: "How is this different from a private-party sale?", a: "You get competing offers from multiple franchised dealers in one place instead of negotiating one buyer at a time." },
      { q: "What if my Camry has cosmetic damage?", a: "List it anyway \u2014 dealers factor reconditioning into their bid, so you still get a real offer instead of no offer." },
    ],
    siblingSlugs: ["sell-my-honda-accord", "sell-my-toyota-corolla", "sell-my-honda-civic"],
  },
  {
    slug: "sell-my-honda-accord",
    make: "Honda",
    model: "Accord",
    yearRange: "2017–2019",
    intro:
      "The Accord\u2019s dealer demand is tightly tied to trim and drivetrain history \u2014 a well-kept EX-L " +
      "with service records will draw sharper bids than a base LX with gaps in maintenance. Competitive " +
      "bidding from multiple dealers is the fastest way to find out which is true for yours.",
    dealerWantsNote: "Dealers pay up for EX-L/Touring trims and any Accord with a documented timing/maintenance history.",
    valueRanges: [
      { band: "75k\u2013100k mi, EX/EX-L", note: "strong dealer turnover, top of the range for this segment" },
      { band: "100k\u2013130k mi, LX/Sport", note: "still sellable, wider bid spread between dealers" },
    ],
    faqs: [
      { q: "Does an Accord with a CVT transmission sell for less?", a: "Dealers price in CVT maintenance history rather than penalizing the transmission type outright \u2014 service records matter more than the spec sheet." },
      { q: "Is a 4-cylinder or V6 Accord worth more to dealers?", a: "4-cylinder Accords are more common on used lots and turn over faster, so demand is usually comparable or slightly higher despite the V6\u2019s power edge." },
      { q: "How fast can I get offers?", a: "Submit your VIN once and dealers in your area bid within a short competitive window \u2014 no back-and-forth with individual buyers." },
    ],
    siblingSlugs: ["sell-my-toyota-camry", "sell-my-honda-civic", "sell-my-nissan-altima"],
  },
  {
    slug: "sell-my-honda-civic",
    make: "Honda",
    model: "Civic",
    yearRange: "2017–2019",
    intro:
      "Civics move fast on dealer lots, especially Sport and EX trims \u2014 that turnover speed is exactly " +
      "why franchised dealers compete hard for them instead of letting a used-Civic buyer walk to a " +
      "private seller.",
    dealerWantsNote: "Sport and Si trims draw the sharpest bids; manual transmissions are a smaller but enthusiastic niche.",
    valueRanges: [
      { band: "70k\u201395k mi, LX/EX", note: "high dealer turnover, competitive bidding typical" },
      { band: "95k\u2013125k mi, Sport", note: "still strong demand given brand reliability reputation" },
    ],
    faqs: [
      { q: "Do dealers care if my Civic is a manual?", a: "Manuals are a smaller pool of buyers but often draw enthusiastic, above-average bids from dealers who know they move fast to a specific customer base." },
      { q: "Is a Civic with over 100k miles still worth listing?", a: "Yes \u2014 Honda\u2019s reliability reputation keeps dealer interest strong well past 100k, especially with documented maintenance." },
    ],
    siblingSlugs: ["sell-my-toyota-corolla", "sell-my-honda-accord", "sell-my-toyota-camry"],
  },
  {
    slug: "sell-my-toyota-corolla",
    make: "Toyota",
    model: "Corolla",
    yearRange: "2017–2019",
    intro:
      "Corollas are the definition of a dealer\u2019s easy inventory \u2014 low reconditioning cost, fast " +
      "turnover, broad buyer appeal. That predictability is what drives multiple dealers to bid " +
      "competitively rather than one buyer trying to lowball.",
    dealerWantsNote: "LE and SE trims with clean interiors move fastest; dealers discount less for mileage here than on most models.",
    valueRanges: [
      { band: "80k\u2013110k mi, LE", note: "steady, predictable dealer demand" },
      { band: "110k\u2013140k mi, any trim", note: "still sellable given low reconditioning cost" },
    ],
    faqs: [
      { q: "Is a Corolla worth listing at 130k+ miles?", a: "Yes \u2014 low reconditioning cost keeps dealer margins healthy even at higher mileage, so bids stay reasonable." },
      { q: "Does a Corolla\u2019s small size limit dealer interest?", a: "No \u2014 compact sedans have consistent used-lot demand from budget-conscious buyers, which keeps dealer bidding active." },
    ],
    siblingSlugs: ["sell-my-honda-civic", "sell-my-toyota-camry", "sell-my-nissan-altima"],
  },
  {
    slug: "sell-my-nissan-altima",
    make: "Nissan",
    model: "Altima",
    yearRange: "2017–2019",
    intro:
      "Altima values are more sensitive to CVT maintenance history than most sedans in this class \u2014 " +
      "a documented service record materially changes what dealers are willing to bid, which is exactly " +
      "the kind of detail that gets lost in a single private-party negotiation.",
    dealerWantsNote: "SR trims with documented CVT service history draw the most competitive dealer bids.",
    valueRanges: [
      { band: "75k\u2013100k mi, SV/SR, documented CVT service", note: "top of range for this model" },
      { band: "100k\u2013130k mi, unclear CVT history", note: "wider bid spread \u2014 worth listing to find your best offer" },
    ],
    faqs: [
      { q: "Does CVT history really affect the offer?", a: "Yes, more than most other maintenance items \u2014 dealers price in CVT risk, so documented service history meaningfully improves bids." },
      { q: "Are all-wheel-drive Altimas worth more?", a: "AWD trims are less common and often draw a modest premium from dealers stocking for winter-climate buyers." },
    ],
    siblingSlugs: ["sell-my-honda-accord", "sell-my-toyota-camry", "sell-my-toyota-corolla"],
  },
];
