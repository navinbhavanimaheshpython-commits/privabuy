import { useEffect, useRef, useState, useCallback } from "react";
 
/* ─── FONTS ─────────────────────────────────────────────────────────────── */
const FontLink = () => (
  <style>{`
    @import url('https://fonts.googleapis.com/css2?family=Instrument+Serif:ital@0;1&family=Barlow:wght@300;400;500;600&display=swap');
 
    *, *::before, *::after { box-sizing: border-box; }
 
    :root {
      --bg: #f5f3ef;
      --fg: #1a1814;
      --muted: rgba(26,24,20,0.52);
      --border: rgba(26,24,20,0.10);
      --card-bg: rgba(255,255,255,0.55);
      --radius-pill: 9999px;
      --accent: #7c5cbf;
      --accent2: #c27c2a;
      --accent3: #2a9e7c;
    }
 
    html { scroll-behavior: smooth; }
 
    body {
      margin: 0;
      font-family: 'Barlow', sans-serif;
      font-weight: 300;
      background: #f5f3ef;
      color: #1a1814;
      overflow-x: hidden;
    }
 
    h1, h2 { color: #1a1814 !important; }
 
    /* ── Liquid Glass (light) ── */
    .lg {
      background: rgba(255,255,255,0.72);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      box-shadow: inset 0 1px 1px rgba(255,255,255,0.85), 0 2px 12px rgba(26,24,20,0.10);
      position: relative;
      overflow: hidden;
    }
    .lg::before {
      content: '';
      position: absolute;
      inset: 0;
      border-radius: inherit;
      padding: 1.4px;
      background: linear-gradient(180deg,
        rgba(255,255,255,0.90) 0%, rgba(255,255,255,0.45) 20%,
        rgba(255,255,255,0.00) 40%, rgba(255,255,255,0.00) 60%,
        rgba(255,255,255,0.45) 80%, rgba(255,255,255,0.90) 100%);
      -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
      -webkit-mask-composite: xor;
      mask-composite: exclude;
      pointer-events: none;
    }
 
    .lg-strong {
      background: rgba(26,24,20,0.88);
      backdrop-filter: blur(50px);
      -webkit-backdrop-filter: blur(50px);
      box-shadow: 4px 4px 12px rgba(26,24,20,0.18), inset 0 1px 1px rgba(255,255,255,0.12);
      position: relative;
      overflow: hidden;
    }
    .lg-strong::before {
      content: '';
      position: absolute;
      inset: 0;
      border-radius: inherit;
      padding: 1.4px;
      background: linear-gradient(180deg,
        rgba(255,255,255,0.30) 0%, rgba(255,255,255,0.10) 20%,
        rgba(255,255,255,0.00) 40%, rgba(255,255,255,0.00) 60%,
        rgba(255,255,255,0.10) 80%, rgba(255,255,255,0.30) 100%);
      -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
      -webkit-mask-composite: xor;
      mask-composite: exclude;
      pointer-events: none;
    }
 
    .serif-italic {
      font-family: 'Instrument Serif', serif;
      font-style: italic;
    }
 
    .section-badge {
      display: inline-block;
      font-family: 'Barlow', sans-serif;
      font-size: 0.72rem;
      font-weight: 500;
      color: #1a1814;
      margin-bottom: 1.1rem;
      padding: 0.25rem 0.875rem;
      border-radius: 9999px;
      letter-spacing: 0.06em;
      text-transform: uppercase;
      border: 1px solid rgba(26,24,20,0.15);
      background: rgba(26,24,20,0.05);
    }
 
    /* grain */
    .grain {
      position: fixed;
      inset: 0;
      pointer-events: none;
      z-index: 200;
      opacity: 0.032;
      background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
      background-size: 128px 128px;
    }
 
    /* hero fade */
    .hero-fade {
      position: absolute;
      bottom: 0; left: 0; right: 0;
      height: 260px;
      background: linear-gradient(to bottom, transparent 0%, rgba(245,243,239,0.55) 45%, rgba(245,243,239,0.92) 80%, #f5f3ef 100%);
      z-index: 5;
      pointer-events: none;
    }
 
    /* Animations */
    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(22px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes drift1 {
      0%,100% { transform: translate(0,0) scale(1); }
      33%      { transform: translate(18px,-12px) scale(1.04); }
      66%      { transform: translate(-14px,10px) scale(0.97); }
    }
    @keyframes drift2 {
      0%,100% { transform: translate(0,0) scale(1); }
      33%      { transform: translate(-20px,14px) scale(0.96); }
      66%      { transform: translate(16px,-8px) scale(1.03); }
    }
    @keyframes pulseRing {
      0%   { transform: scale(0.85); opacity: 0.7; }
      100% { transform: scale(1.6);  opacity: 0; }
    }
    @keyframes countUp {
      from { opacity: 0; transform: translateY(8px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    @keyframes shimmer {
      0%   { transform: translateX(-100%); }
      100% { transform: translateX(100%); }
    }
    @keyframes timerTick {
      0%,100% { opacity:1; }
      50%      { opacity:0.5; }
    }
    @keyframes bidPop {
      0%   { transform: scale(1); }
      50%  { transform: scale(1.04); }
      100% { transform: scale(1); }
    }
 
    .fade-up-1 { animation: fadeUp 0.9s ease both; animation-delay: 0.1s; }
    .fade-up-2 { animation: fadeUp 0.9s ease both; animation-delay: 0.35s; }
    .fade-up-3 { animation: fadeUp 0.9s ease both; animation-delay: 0.6s; }
    .fade-up-4 { animation: fadeUp 0.9s ease both; animation-delay: 0.85s; }
 
    /* scroll reveal */
    .reveal { opacity: 0; transform: translateY(28px); transition: opacity 0.85s ease, transform 0.85s ease; }
    .reveal.visible { opacity: 1; transform: translateY(0); }
 
    /* Auction demo */
    .bid-row { transition: background 0.3s; }
    .bid-row:hover { background: rgba(26,24,20,0.04); }
 
    .progress-bar {
      height: 3px;
      border-radius: 2px;
      background: rgba(26,24,20,0.10);
      overflow: hidden;
      position: relative;
    }
    .progress-bar-fill {
      height: 100%;
      border-radius: 2px;
      background: linear-gradient(to right, var(--accent), var(--accent2));
      transition: width 1.5s ease;
    }
 
    /* Step connector line */
    .step-line {
      position: absolute;
      left: 22px;
      top: 44px;
      bottom: -40px;
      width: 1px;
      background: linear-gradient(to bottom, rgba(26,24,20,0.15), transparent);
    }
 
    /* stat card shimmer */
    .stat-shimmer::after {
      content: '';
      position: absolute;
      inset: 0;
      background: linear-gradient(105deg, transparent 40%, rgba(255,255,255,0.35) 50%, transparent 60%);
      animation: shimmer 3s infinite;
    }
 
    /* nav scroll shadow */
    .nav-scrolled {
      box-shadow: 0 8px 40px rgba(26,24,20,0.12), 0 2px 0 rgba(255,255,255,0.70);
    }
  `}</style>
);
 
/* ─── SVG ICON COMPONENTS ───────────────────────────────────────────────── */
const iconStroke = { fill:"none", strokeLinecap:"round", strokeLinejoin:"round", strokeWidth:"1.6" };
 
function CarIcon() {
  return (
    <svg width="28" height="28" viewBox="0 0 24 24" style={{...iconStroke, stroke:"#7c5cbf"}}>
      <path d="M5 17H3a2 2 0 0 1-2-2v-4a2 2 0 0 1 2-2h1l2-4h12l2 4h1a2 2 0 0 1 2 2v4a2 2 0 0 1-2 2h-2"/>
      <circle cx="7.5" cy="17" r="1.5"/><circle cx="16.5" cy="17" r="1.5"/>
      <path d="M7.5 17h9"/>
    </svg>
  );
}
 
function StepIcon({ name, color }) {
  const s = {...iconStroke, stroke: color || "var(--accent)"};
  const icons = {
    clipboard: (
      <svg width="20" height="20" viewBox="0 0 24 24" style={s}>
        <rect x="9" y="2" width="6" height="4" rx="1"/>
        <path d="M9 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2h-3"/>
        <path d="M9 12h6M9 16h4"/>
      </svg>
    ),
    broadcast: (
      <svg width="20" height="20" viewBox="0 0 24 24" style={s}>
        <path d="M4.93 4.93a10 10 0 0 0 0 14.14"/>
        <path d="M19.07 4.93a10 10 0 0 1 0 14.14"/>
        <path d="M7.76 7.76a6 6 0 0 0 0 8.48"/>
        <path d="M16.24 7.76a6 6 0 0 1 0 8.48"/>
        <circle cx="12" cy="12" r="1.5"/>
      </svg>
    ),
    timer: (
      <svg width="20" height="20" viewBox="0 0 24 24" style={s}>
        <circle cx="12" cy="13" r="8"/>
        <path d="M12 9v4l3 2"/>
        <path d="M9 2h6M12 2v3"/>
      </svg>
    ),
    checkCircle: (
      <svg width="20" height="20" viewBox="0 0 24 24" style={s}>
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
        <path d="M22 4 12 14.01l-3-3"/>
      </svg>
    ),
  };
  return icons[name] || null;
}
 
function PerkIcon({ name }) {
  const s = {...iconStroke, stroke:"var(--accent)"};
  const icons = {
    target: (
      <svg width="22" height="22" viewBox="0 0 24 24" style={s}>
        <circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/>
      </svg>
    ),
    barChart: (
      <svg width="22" height="22" viewBox="0 0 24 24" style={s}>
        <path d="M18 20V10M12 20V4M6 20v-6"/>
      </svg>
    ),
    zap: (
      <svg width="22" height="22" viewBox="0 0 24 24" style={s}>
        <path d="M13 2 3 14h9l-1 8 10-12h-9l1-8z"/>
      </svg>
    ),
    trendingUp: (
      <svg width="22" height="22" viewBox="0 0 24 24" style={s}>
        <path d="m23 6-9.5 9.5-5-5L1 18"/><path d="M17 6h6v6"/>
      </svg>
    ),
    users: (
      <svg width="22" height="22" viewBox="0 0 24 24" style={s}>
        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
        <circle cx="9" cy="7" r="4"/>
        <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/>
      </svg>
    ),
    smartphone: (
      <svg width="22" height="22" viewBox="0 0 24 24" style={s}>
        <rect x="5" y="2" width="14" height="20" rx="2"/>
        <path d="M12 18h.01"/>
      </svg>
    ),
  };
  return icons[name] || null;
}
 
/* ─── PARTICLE CANVAS (hero dust) ──────────────────────────────────────── */
function ParticleCanvas() {
  const ref = useRef(null);
  useEffect(() => {
    const canvas = ref.current;
    if (!canvas) return;
    const ctx = canvas.getContext("2d");
    let raf;
    const COLS = 140;
    const resize = () => {
      canvas.width = canvas.offsetWidth;
      canvas.height = canvas.offsetHeight;
    };
    resize();
    window.addEventListener("resize", resize);
    const pts = Array.from({ length: COLS }, () => ({
      x: Math.random() * canvas.width,
      y: Math.random() * canvas.height,
      r: Math.random() * 1.6 + 0.2,
      baseOpacity: Math.random() * 0.35 + 0.05,
      speed: Math.random() * 0.35 + 0.08,
      drift: (Math.random() - 0.5) * 0.25,
      phase: Math.random() * Math.PI * 2,
    }));
    const draw = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);
      pts.forEach(p => {
        p.y -= p.speed; p.x += p.drift; p.phase += 0.012;
        if (p.y < -4) { p.y = canvas.height + 4; p.x = Math.random() * canvas.width; }
        if (p.x < -4) p.x = canvas.width + 4;
        if (p.x > canvas.width + 4) p.x = -4;
        const op = p.baseOpacity * (0.65 + 0.35 * Math.sin(p.phase));
        const g = ctx.createRadialGradient(p.x, p.y, 0, p.x, p.y, p.r * 2.5);
        g.addColorStop(0, `rgba(26,24,20,${op})`);
        g.addColorStop(1, "rgba(26,24,20,0)");
        ctx.beginPath(); ctx.arc(p.x, p.y, p.r * 2.5, 0, Math.PI * 2);
        ctx.fillStyle = g; ctx.fill();
      });
      raf = requestAnimationFrame(draw);
    };
    draw();
    return () => { cancelAnimationFrame(raf); window.removeEventListener("resize", resize); };
  }, []);
  return <canvas ref={ref} style={{ position:"absolute", inset:0, width:"100%", height:"100%", pointerEvents:"none", zIndex:2 }} />;
}
 
/* ─── SCROLL REVEAL HOOK ────────────────────────────────────────────────── */
function useReveal() {
  useEffect(() => {
    const els = document.querySelectorAll(".reveal");
    const io = new IntersectionObserver(entries => {
      entries.forEach(e => { if (e.isIntersecting) { e.target.classList.add("visible"); io.unobserve(e.target); } });
    }, { threshold: 0.12 });
    els.forEach(el => io.observe(el));
    return () => io.disconnect();
  });
}
 
/* ─── NAVBAR ────────────────────────────────────────────────────────────── */
function Navbar() {
  const [scrolled, setScrolled] = useState(false);
  useEffect(() => {
    const h = () => setScrolled(window.scrollY > 30);
    window.addEventListener("scroll", h);
    return () => window.removeEventListener("scroll", h);
  }, []);
  return (
    <div style={{ position:"fixed", top:"1rem", left:"50%", transform:"translateX(-50%)", width:"calc(100% - 3rem)", maxWidth:"none", zIndex:50 }}>
      <div className={`lg fade-up-1 ${scrolled ? "nav-scrolled" : ""}`}
        style={{ borderRadius:"9999px", padding:"0 1.25rem", height:"3.5rem", display:"flex", alignItems:"center", gap:"1rem" }}>
        {/* Logo */}
        <div style={{ flex:1 }}>
          <span className="serif-italic" style={{ fontSize:"1.25rem", fontWeight:400, letterSpacing:"-0.02em", color:"#1a1814" }}>
            Priva<span style={{ color:"var(--accent)" }}>Buy</span>
          </span>
        </div>
        {/* Nav */}
        <div style={{ display:"flex", gap:"1.75rem", flexShrink:0 }}>
          {["How It Works","For Sellers","For Dealers","FAQ"].map(l => (
            <a key={l} href={`#${l.toLowerCase().replace(/ /g,"-")}`}
              style={{ fontSize:"0.82rem", color:"rgba(26,24,20,0.88)", textDecoration:"none", fontWeight:400, transition:"color 0.2s" }}
              onMouseEnter={e=>e.target.style.color="#1a1814"} onMouseLeave={e=>e.target.style.color="rgba(26,24,20,0.74)"}>
              {l}
            </a>
          ))}
        </div>
        {/* CTA */}
        <div style={{ flex:1, display:"flex", justifyContent:"flex-end" }}>
          <button style={{ background:"#1a1814", color:"#f5f3ef", border:"none", borderRadius:"9999px", padding:"0.4rem 1.1rem", fontSize:"0.82rem", fontWeight:500, cursor:"pointer", display:"flex", alignItems:"center", gap:"0.3rem", fontFamily:"Barlow, sans-serif" }}>
            List Your Car <span style={{ fontSize:"0.85rem" }}>↗</span>
          </button>
        </div>
      </div>
    </div>
  );
}
 
/* ─── LIVE AUCTION DEMO WIDGET ──────────────────────────────────────────── */
function AuctionDemo() {
  const [bids, setBids] = useState([
    { dealer:"Riverside Auto", amount:11400, time:"14:51", color:"var(--accent)" },
    { dealer:"Summit Motors",  amount:11100, time:"14:49", color:"var(--accent2)" },
    { dealer:"Apex Ford",      amount:10850, time:"14:47", color:"var(--accent3)" },
  ]);
  const [timer, setTimer] = useState(743);
  const [highlight, setHighlight] = useState(null);
 
  useEffect(() => {
    const iv = setInterval(() => setTimer(t => t > 0 ? t - 1 : 0), 1000);
    return () => clearInterval(iv);
  }, []);
 
  useEffect(() => {
    if (timer === 0) return;
    const iv = setInterval(() => {
      const dealers = ["Northside CDJR","Lakeview Kia","Metro Auto Group","Valley Honda","Prestige Pre-Owned"];
      const pick = dealers[Math.floor(Math.random()*dealers.length)];
      const top = bids[0].amount;
      const newAmt = top + Math.floor(Math.random()*250+100);
      const colors = ["var(--accent)","var(--accent2)","var(--accent3)"];
      setBids(prev => {
        const next = [{ dealer:pick, amount:newAmt, time:fmtTime(), color:colors[Math.floor(Math.random()*3)] }, ...prev].slice(0,5);
        return next;
      });
      setHighlight(0);
      setTimeout(() => setHighlight(null), 900);
    }, 4800);
    return () => clearInterval(iv);
  }, [bids, timer]);
 
  const fmtTime = () => {
    const d = new Date();
    return `${String(d.getHours()).padStart(2,"0")}:${String(d.getMinutes()).padStart(2,"0")}`;
  };
  const mm = String(Math.floor(timer/60)).padStart(2,"0");
  const ss = String(timer%60).padStart(2,"0");
  const pct = Math.min(100, (900-timer)/900*100);
 
  return (
    <div className="lg" style={{ borderRadius:"1.75rem", padding:"2.25rem", width:"100%", border:"1px solid rgba(26,24,20,0.08)" }}>
      {/* Car info */}
      <div style={{ display:"flex", gap:"1rem", marginBottom:"1.25rem", alignItems:"center" }}>
        <div style={{ width:56, height:56, borderRadius:"0.875rem", background:"linear-gradient(135deg,rgba(124,92,191,0.12),rgba(194,124,42,0.08))", border:"1px solid rgba(26,24,20,0.10)", display:"flex", alignItems:"center", justifyContent:"center" }}>
          <CarIcon />
        </div>
        <div>
          <div style={{ fontWeight:500, fontSize:"1.1rem", letterSpacing:"-0.01em", color:"#1a1814" }}>2019 Honda Accord EX</div>
          <div style={{ color:"rgba(26,24,20,0.82)", fontSize:"0.85rem", marginTop:"0.2rem" }}>94,200 mi · VIN: 1HGCV1F34KA0••••••</div>
        </div>
        <div style={{ marginLeft:"auto", textAlign:"right" }}>
          <div style={{ fontSize:"0.65rem", color:"rgba(26,24,20,0.88)", marginBottom:"0.2rem", textTransform:"uppercase", letterSpacing:"0.06em" }}>Top Bid</div>
          <div style={{ fontFamily:"Instrument Serif, serif", fontStyle:"italic", fontSize:"1.65rem", color:"var(--accent)" }}>
            ${bids[0]?.amount.toLocaleString()}
          </div>
        </div>
      </div>
 
      {/* Timer */}
      <div style={{ marginBottom:"1rem" }}>
        <div style={{ display:"flex", justifyContent:"space-between", alignItems:"center", marginBottom:"0.5rem" }}>
          <span style={{ fontSize:"0.72rem", color:"rgba(26,24,20,0.88)", textTransform:"uppercase", letterSpacing:"0.06em" }}>Time Remaining</span>
          <span style={{ fontFamily:"'Barlow', monospace", fontSize:"1.05rem", fontWeight:500, color:timer < 120 ? "#c05a2a" : "rgba(26,24,20,0.80)", animation: timer < 120 ? "timerTick 1s infinite" : "none" }}>
            {mm}:{ss}
          </span>
        </div>
        <div className="progress-bar">
          <div className="progress-bar-fill" style={{ width:`${100 - pct}%` }} />
        </div>
      </div>
 
      {/* Bids */}
      <div style={{ fontSize:"0.72rem", color:"rgba(26,24,20,0.88)", textTransform:"uppercase", letterSpacing:"0.08em", marginBottom:"0.5rem" }}>Live Bids</div>
      <div style={{ display:"flex", flexDirection:"column", gap:"0.15rem" }}>
        {bids.map((b,i) => (
          <div key={b.dealer+b.time+i} className="bid-row" style={{
            display:"flex", alignItems:"center", justifyContent:"space-between",
            padding:"0.5rem 0.6rem", borderRadius:"0.6rem",
            background: i === highlight ? "rgba(124,92,191,0.07)" : "transparent",
            animation: i === highlight ? "bidPop 0.5s ease" : "none",
            transition:"background 0.4s"
          }}>
            <div style={{ display:"flex", alignItems:"center", gap:"0.5rem" }}>
              <div style={{ width:6, height:6, borderRadius:"50%", background:b.color, flexShrink:0 }} />
              <span style={{ fontSize:"0.95rem", color: i===0 ? "#1a1814" : "rgba(26,24,20,0.48)" }}>{b.dealer}</span>
            </div>
            <div style={{ display:"flex", alignItems:"center", gap:"0.75rem" }}>
              <span style={{ fontSize:"0.7rem", color:"rgba(26,24,20,0.86)" }}>{b.time}</span>
              <span style={{ fontSize:"1rem", fontWeight: i===0 ? 500 : 400, color: i===0 ? b.color : "rgba(26,24,20,0.42)" }}>
                ${b.amount.toLocaleString()}
              </span>
            </div>
          </div>
        ))}
      </div>
 
      {/* Dealer count */}
      <div style={{ marginTop:"1rem", paddingTop:"1rem", borderTop:"1px solid rgba(26,24,20,0.14)", display:"flex", alignItems:"center", justifyContent:"space-between" }}>
        <div style={{ display:"flex", alignItems:"center", gap:"0.5rem" }}>
          <div style={{ display:"flex" }}>
            {[0,1,2,3,4].map(i => (
              <div key={i} style={{ width:22, height:22, borderRadius:"50%", border:"1.5px solid #f5f3ef", marginLeft: i>0?-7:0, background:`hsl(${i*55+220},35%,${60+i*5}%)`, display:"flex", alignItems:"center", justifyContent:"center", fontSize:"0.55rem", color:"rgba(255,255,255,0.9)", fontWeight:500 }}>D</div>
            ))}
          </div>
          <span style={{ fontSize:"0.75rem", color:"rgba(26,24,20,0.80)" }}>5 dealers bidding</span>
        </div>
        <div style={{ display:"flex", alignItems:"center", gap:"0.35rem" }}>
          <div style={{ width:6, height:6, borderRadius:"50%", background:"#22a865", animation:"pulseRing 1.5s infinite" }} />
          <span style={{ fontSize:"0.72rem", color:"#22a865" }}>Live</span>
        </div>
      </div>
    </div>
  );
}
 
/* ─── HERO ──────────────────────────────────────────────────────────────── */
function Hero() {
  return (
    <section style={{ minHeight:"100vh", background:"#f5f3ef", overflow:"hidden", position:"relative", display:"flex", alignItems:"flex-start" }}>
      {/* Ambient blobs */}
      <div style={{ position:"absolute", inset:0, zIndex:1, overflow:"hidden", pointerEvents:"none" }}>
        <div style={{ position:"absolute", width:"55vw", height:"55vw", borderRadius:"50%", background:"radial-gradient(circle, rgba(124,92,191,0.18) 0%, transparent 68%)", top:"-20%", left:"-12%", animation:"drift1 18s ease-in-out infinite" }} />
        <div style={{ position:"absolute", width:"48vw", height:"48vw", borderRadius:"50%", background:"radial-gradient(circle, rgba(194,124,42,0.14) 0%, transparent 68%)", bottom:"-15%", right:"-10%", animation:"drift2 22s ease-in-out infinite" }} />
        <div style={{ position:"absolute", width:"42vw", height:"42vw", borderRadius:"50%", background:"radial-gradient(circle, rgba(42,158,124,0.12) 0%, transparent 68%)", top:"15%", left:"30%", animation:"drift1 25s ease-in-out infinite reverse" }} />
        <div style={{ position:"absolute", width:"30vw", height:"30vw", borderRadius:"50%", background:"radial-gradient(circle, rgba(124,92,191,0.08) 0%, transparent 65%)", bottom:"5%", left:"15%", animation:"drift2 20s ease-in-out infinite" }} />
      </div>
      <ParticleCanvas />
 
      {/* Content */}
      <div style={{ position:"relative", zIndex:10, width:"100%", paddingTop:"6rem", paddingBottom:"4rem", paddingLeft:"clamp(1.5rem, 6vw, 5rem)", paddingRight:"clamp(1.5rem, 6vw, 5rem)", display:"flex", flexDirection:"column", alignItems:"center", textAlign:"center" }}>
 
        {/* Badge */}
        <div className="lg fade-up-1" style={{ display:"inline-flex", alignItems:"center", gap:"0.5rem", borderRadius:"9999px", padding:"0.25rem 1rem 0.25rem 0.35rem", marginBottom:"1.75rem", border:"1px solid rgba(26,24,20,0.10)" }}>
          <span style={{ background:"#1a1814", color:"#f5f3ef", borderRadius:"9999px", fontSize:"0.65rem", fontWeight:600, padding:"0.15rem 0.5rem", letterSpacing:"0.04em" }}>NEW</span>
          <span style={{ fontSize:"0.8rem", color:"rgba(26,24,20,0.88)" }}>The smarter way to sell your used car.</span>
        </div>
 
        {/* Headline */}
        <h1 className="serif-italic fade-up-2" style={{ fontSize:"clamp(3.5rem, 7.5vw, 8rem)", lineHeight:0.9, letterSpacing:"-0.04em", margin:"0 0 1.75rem", fontWeight:400, color:"#1a1814", textShadow:"0 2px 40px rgba(245,243,239,0.9)", maxWidth:"18ch" }}>
          The <span style={{ color:"var(--accent)" }}>highest offer</span><br />
          your car will ever get.<br />
          Done in 15 minutes.
        </h1>
 
        {/* Subtext */}
        <p className="fade-up-3" style={{ color:"#1a1814", fontSize:"clamp(0.95rem, 1.1vw, 1.1rem)", lineHeight:1.65, maxWidth:"52ch", margin:"0 0 2.25rem", fontWeight:400 }}>
          List your 6–8 year old vehicle and watch 5 local dealers compete for it in a live 15-minute auction. More competition. Bigger offers. No haggling.
        </p>
 
        {/* CTAs */}
        <div className="fade-up-4" style={{ display:"flex", gap:"0.75rem", flexWrap:"wrap", justifyContent:"center", marginBottom:"2.75rem" }}>
          <button className="lg-strong" onClick={() => window.location.href='/app?role=seller'} style={{ borderRadius:"9999px", padding:"0.9rem 2rem", fontSize:"1rem", fontWeight:500, color:"#f5f3ef", border:"none", cursor:"pointer", fontFamily:"Barlow, sans-serif", display:"flex", alignItems:"center", gap:"0.4rem" }}>
            List Your Car ↗
          </button>
          <button className="lg" onClick={() => window.location.href='/dealer-signup'} style={{ borderRadius:"9999px", padding:"0.9rem 1.75rem", fontSize:"1rem", color:"rgba(26,24,20,0.88)", border:"1px solid rgba(26,24,20,0.12)", cursor:"pointer", fontFamily:"Barlow, sans-serif", background:"rgba(255,255,255,0.4)" }}>
            I'm a Dealer →
          </button>
        </div>
 
        {/* Trust stats row */}
        <div className="fade-up-4" style={{ display:"flex", gap:"clamp(2rem, 5vw, 5rem)", justifyContent:"center", flexWrap:"wrap", marginBottom:"3rem" }}>
          {[["$2,400", "avg. more vs private sale"],["15 min","live auction window"],["5 dealers","compete per listing"]].map(([v,l]) => (
            <div key={v} style={{ display:"flex", flexDirection:"column", alignItems:"center" }}>
              <span className="serif-italic" style={{ fontSize:"clamp(1.4rem, 2vw, 1.8rem)", color:"var(--accent)", lineHeight:1 }}>{v}</span>
              <span style={{ fontSize:"0.82rem", fontWeight:400, color:"rgba(26,24,20,0.72)", marginTop:"0.35rem" }}>{l}</span>
            </div>
          ))}
        </div>
 
        {/* Auction card */}
        <div className="fade-up-4" style={{ width:"100%", maxWidth:"680px" }}>
          <AuctionDemo />
        </div>
 
      </div>
 
      <div className="hero-fade" />
    </section>
  );
}
 
/* ─── HOW IT WORKS ──────────────────────────────────────────────────────── */
const steps = [
  { n:"01", title:"List in 3 minutes", body:"Enter your VIN and mileage. We pull the vehicle history, photos, and market comps automatically. No lengthy forms.", icon:"clipboard", color:"var(--accent)" },
  { n:"02", title:"5 dealers are notified", body:"Our system immediately alerts the 5 highest-rated dealers within 50 miles who actively buy your vehicle type.", icon:"broadcast", color:"var(--accent2)" },
  { n:"03", title:"15-minute live auction", body:"Watch real bids roll in on your phone. Dealers compete knowing only one can win — pushing offers higher than they'd go one-on-one.", icon:"timer", color:"var(--accent3)" },
  { n:"04", title:"Accept & hand off", body:"Accept the best offer. The winning dealer arranges pickup or drop-off. You get paid. Done.", icon:"checkCircle", color:"var(--accent)" },
];
 
function HowItWorks() {
  return (
    <section id="how-it-works" style={{ background:"#f5f3ef", padding:"7rem 1.5rem" }}>
      <div style={{ maxWidth:"64rem", margin:"0 auto" }}>
        <div className="reveal" style={{ textAlign:"center", marginBottom:"4rem" }}>
          <span className="section-badge">How It Works</span>
          <h2 className="serif-italic" style={{ fontSize:"clamp(2.2rem,5vw,3.5rem)", lineHeight:0.93, letterSpacing:"-0.04em", margin:"0 0 1rem", fontWeight:400 }}>
            List today.<br />Get paid today.
          </h2>
          <p style={{ color:"rgba(26,24,20,0.84)", fontSize:"1rem", maxWidth:480, margin:"0 auto" }}>
            The whole process takes under an hour. Here's how we turn your unused car into a competitive bidding war.
          </p>
        </div>
 
        <div style={{ display:"grid", gridTemplateColumns:"repeat(auto-fit, minmax(240px, 1fr))", gap:"1.25rem" }}>
          {steps.map((s, i) => (
            <div key={s.n} className="reveal" style={{ transitionDelay:`${i*0.12}s` }}>
              <div className="lg" style={{ borderRadius:"1.5rem", padding:"1.75rem", height:"100%", position:"relative", overflow:"hidden", border:"1px solid rgba(26,24,20,0.14)" }}>
                {/* shimmer top line */}
                <div style={{ position:"absolute", top:0, left:"1.5rem", right:"1.5rem", height:"1px", background:"linear-gradient(to right, transparent, rgba(255,255,255,0.9), transparent)" }} />
                <div style={{ display:"flex", alignItems:"center", gap:"0.75rem", marginBottom:"1rem" }}>
                  <div style={{ width:42, height:42, borderRadius:"0.875rem", background:`linear-gradient(135deg, rgba(26,24,20,0.06), rgba(26,24,20,0.02))`, border:"1px solid rgba(26,24,20,0.08)", display:"flex", alignItems:"center", justifyContent:"center" }}><StepIcon name={s.icon} color={s.color} /></div>
                  <span style={{ fontFamily:"Barlow", fontWeight:300, fontSize:"0.7rem", color:"rgba(26,24,20,0.86)", letterSpacing:"0.08em" }}>{s.n}</span>
                </div>
                <div style={{ fontSize:"0.95rem", fontWeight:500, marginBottom:"0.6rem", color:"#1a1814", letterSpacing:"-0.01em" }}>{s.title}</div>
                <div style={{ fontSize:"0.85rem", color:"rgba(26,24,20,0.82)", lineHeight:1.65, fontWeight:300 }}>{s.body}</div>
                <div style={{ position:"absolute", bottom:0, left:0, right:0, height:"2px", background:`linear-gradient(to right, transparent, ${s.color}55, transparent)`, borderRadius:"0 0 1.5rem 1.5rem" }} />
              </div>
            </div>
          ))}
        </div>
 
        {/* Have more questions CTA */}
        <div className="reveal" style={{ textAlign:"center", marginTop:"3rem" }}>
          <a href="#faq" style={{ display:"inline-flex", alignItems:"center", gap:"0.5rem", textDecoration:"none", borderRadius:"9999px", padding:"0.75rem 1.75rem", fontSize:"0.88rem", fontWeight:500, color:"#1a1814", border:"1px solid rgba(26,24,20,0.18)", background:"rgba(255,255,255,0.72)", backdropFilter:"blur(10px)", WebkitBackdropFilter:"blur(10px)", transition:"background 0.2s, box-shadow 0.2s", fontFamily:"Barlow, sans-serif" }}
            onMouseEnter={e=>{ e.currentTarget.style.background="rgba(255,255,255,0.95)"; e.currentTarget.style.boxShadow="0 4px 20px rgba(26,24,20,0.10)"; }}
            onMouseLeave={e=>{ e.currentTarget.style.background="rgba(255,255,255,0.72)"; e.currentTarget.style.boxShadow=""; }}>
            Have more questions?
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M12 5v14M5 12l7 7 7-7"/>
            </svg>
          </a>
        </div>
 
      </div>
    </section>
  );
}
 
/* ─── FOR SELLERS ───────────────────────────────────────────────────────── */
function ForSellers() {
  const stats = [
    { value:"$2,400+", label:"avg. over private listing", color:"var(--accent)" },
    { value:"94%", label:"of listings receive 5 bids", color:"var(--accent2)" },
    { value:"< 1hr", label:"start to accepted offer", color:"var(--accent3)" },
    { value:"Zero", label:"fees for sellers. Ever.", color:"var(--accent)" },
  ];
  return (
    <section id="for-sellers" style={{ background:"#f5f3ef", padding:"7rem 1.5rem", overflow:"hidden" }}>
      <div style={{ maxWidth:"64rem", margin:"0 auto" }}>
        <div style={{ display:"flex", gap:"4rem", flexWrap:"wrap", alignItems:"center" }}>
          {/* Left text */}
          <div style={{ flex:"1 1 300px" }} className="reveal">
            <span className="section-badge">For Sellers</span>
            <h2 className="serif-italic" style={{ fontSize:"clamp(2.2rem,5vw,3.5rem)", lineHeight:0.93, letterSpacing:"-0.04em", margin:"0 0 1.25rem", fontWeight:400 }}>
              Stop leaving<br />money on<br />the table.
            </h2>
            <p style={{ color:"rgba(26,24,20,0.84)", fontSize:"1rem", lineHeight:1.65, maxWidth:420, marginBottom:"1.75rem" }}>
              Facebook Marketplace and Craigslist mean one buyer, zero competition, and you absorbing all the lowball offers. PrivaBuy flips the dynamic — dealers fight for your car because they know these 6–8 year old vehicles carry serious profit margins.
            </p>
            <div style={{ display:"flex", flexDirection:"column", gap:"0.6rem" }}>
              {["No fees, ever — dealers pay us","Instant VIN pull, no manual entry","Real offers from licensed dealers only","Pickup or drop-off arranged for you"].map(t => (
                <div key={t} style={{ display:"flex", alignItems:"center", gap:"0.6rem", fontSize:"0.85rem", color:"rgba(26,24,20,0.88)" }}>
                  <span style={{ color:"var(--accent3)", fontSize:"0.75rem" }}>✦</span> {t}
                </div>
              ))}
            </div>
          </div>
 
          {/* Right stats grid */}
          <div style={{ flex:"1 1 300px", display:"grid", gridTemplateColumns:"1fr 1fr", gap:"1rem" }} className="reveal" >
            {stats.map((s, i) => (
              <div key={s.label} className="lg stat-shimmer" style={{ borderRadius:"1.25rem", padding:"1.5rem", position:"relative", overflow:"hidden", border:"1px solid rgba(26,24,20,0.14)", transitionDelay:`${i*0.1}s` }}>
                <div className="serif-italic" style={{ fontSize:"2rem", color:s.color, lineHeight:1, marginBottom:"0.4rem" }}>{s.value}</div>
                <div style={{ fontSize:"0.78rem", color:"rgba(26,24,20,0.88)", fontWeight:300, lineHeight:1.4 }}>{s.label}</div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
 
/* ─── FOR DEALERS ───────────────────────────────────────────────────────── */
function ForDealers() {
  const perks = [
    { icon:"target", title:"Geo-scoped inventory", body:"Only auctions within your target radius. No wasted time on stock you can't move." },
    { icon:"barChart", title:"Transparent vehicle data", body:"Full Carfax, photos, and condition notes before the auction starts. Bid with confidence." },
    { icon:"zap", title:"Real-time notifications", body:"Instant alerts the moment a matching vehicle lists. Never miss a unit in your sweet spot." },
    { icon:"trendingUp", title:"High-margin stock", body:"6–8 year old vehicles with 80k–120k miles are the bread-and-butter of pre-owned profits. We source the gap." },
    { icon:"users", title:"Exclusive 5-dealer auctions", body:"You're never bidding against 40 anonymous buyers. Five dealers, known market, clean competition." },
    { icon:"smartphone", title:"Bid from anywhere", body:"Mobile-first auction interface. Accept, counter, or pass — from the lot or the office." },
  ];
  return (
    <section id="for-dealers" style={{ background:"#edeae4", padding:"7rem 1.5rem" }}>
      <div style={{ maxWidth:"64rem", margin:"0 auto" }}>
        <div className="reveal" style={{ textAlign:"center", marginBottom:"3.5rem" }}>
          <span className="section-badge">For Dealers</span>
          <h2 className="serif-italic" style={{ fontSize:"clamp(2.2rem,5vw,3.5rem)", lineHeight:0.93, letterSpacing:"-0.04em", margin:"0 0 1rem", fontWeight:400 }}>
            The inventory gap,<br />finally closed.
          </h2>
          <p style={{ color:"rgba(26,24,20,0.84)", fontSize:"1rem", maxWidth:500, margin:"0 auto" }}>
            The 6–8 year old, higher-mileage segment is your most profitable. It's also the hardest to source. PrivaBuy brings it directly to you.
          </p>
        </div>
        <div style={{ display:"grid", gridTemplateColumns:"repeat(auto-fit, minmax(260px, 1fr))", gap:"1.1rem" }}>
          {perks.map((p, i) => (
            <div key={p.title} className="reveal" style={{ transitionDelay:`${i*0.09}s` }}>
              <div className="lg" style={{ borderRadius:"1.25rem", padding:"1.5rem", height:"100%", border:"1px solid rgba(26,24,20,0.14)", position:"relative", overflow:"hidden", transition:"transform 0.3s, box-shadow 0.3s", cursor:"default" }}
                onMouseEnter={e=>{ e.currentTarget.style.transform="translateY(-5px)"; e.currentTarget.style.boxShadow="0 20px 60px rgba(26,24,20,0.18)"; }}
                onMouseLeave={e=>{ e.currentTarget.style.transform=""; e.currentTarget.style.boxShadow=""; }}>
                <div style={{ position:"absolute", top:0, left:"1.25rem", right:"1.25rem", height:"1px", background:"linear-gradient(to right,transparent,rgba(255,255,255,0.9),transparent)" }} />
                <div style={{ marginBottom:"0.75rem" }}><PerkIcon name={p.icon} /></div>
                <div style={{ fontSize:"0.92rem", fontWeight:500, marginBottom:"0.5rem", letterSpacing:"-0.01em", color:"#1a1814" }}>{p.title}</div>
                <div style={{ fontSize:"0.83rem", color:"rgba(26,24,20,0.82)", lineHeight:1.65, fontWeight:300 }}>{p.body}</div>
              </div>
            </div>
          ))}
        </div>
        <div className="reveal" style={{ textAlign:"center", marginTop:"2.5rem" }}>
          <button className="lg-strong" onClick={() => window.location.href='/dealer-signup'} style={{ borderRadius:"9999px", padding:"0.85rem 2rem", fontSize:"0.9rem", color:"#f5f3ef", border:"none", cursor:"pointer", fontFamily:"Barlow, sans-serif", fontWeight:500 }}>
            Apply for Dealer Access ↗
          </button>
        </div>
      </div>
    </section>
  );
}
 
/* ─── FAQ ───────────────────────────────────────────────────────────────── */
const faqs = [
  { q:"What vehicles qualify?", a:"We focus on vehicles that are 6–8 years old with 70,000–130,000 miles. These are the highest-demand units for franchised dealers because they carry strong gross profit margins on pre-owned lots." },
  { q:"Is there a fee for sellers?", a:"Zero. PrivaBuy is completely free for sellers. Dealers pay a transaction fee when they win an auction, so our incentives are aligned: we only make money when you get a great offer." },
  { q:"What if no one bids on my car?", a:"It's rare — over 94% of listings receive the full 5 bids. If an auction closes without meeting your reserve, you keep the car with no obligation whatsoever." },
  { q:"How do dealers know my vehicle's condition?", a:"Before the auction opens, we surface your full VIN history report, any self-reported condition notes, and photos. Dealers can bid confidently; surprises at handoff are a policy violation." },
  { q:"Why only 5 dealers per auction?", a:"More isn't always better. Five geo-scoped dealers create competitive urgency without the chaotic noise of an open marketplace. Each dealer knows they're in a tight race — that's what pushes bids up." },
  { q:"How quickly do I get paid?", a:"After accepting an offer, the winning dealer typically completes payment within 1–2 business days. Most do same-day bank transfers or cashier's checks at pickup." },
];
 
function FAQ() {
  const [open, setOpen] = useState(null);
  return (
    <section id="faq" style={{ background:"#f5f3ef", padding:"7rem 1.5rem" }}>
      <div style={{ maxWidth:"48rem", margin:"0 auto" }}>
        <div className="reveal" style={{ textAlign:"center", marginBottom:"3rem" }}>
          <span className="section-badge">FAQ</span>
          <h2 className="serif-italic" style={{ fontSize:"clamp(2rem,4.5vw,3rem)", lineHeight:0.95, letterSpacing:"-0.04em", margin:"0", fontWeight:400 }}>
            Every question,<br />answered honestly.
          </h2>
        </div>
        <div className="reveal" style={{ display:"flex", flexDirection:"column", gap:"0.6rem" }}>
          {faqs.map((f, i) => (
            <div key={i} className="lg" style={{ borderRadius:"1rem", border:"1px solid rgba(26,24,20,0.14)", overflow:"hidden", cursor:"pointer" }}
              onClick={() => setOpen(open === i ? null : i)}>
              <div style={{ display:"flex", justifyContent:"space-between", alignItems:"center", padding:"1.1rem 1.25rem" }}>
                <span style={{ fontSize:"0.92rem", fontWeight:400, color:"#1a1814" }}>{f.q}</span>
                <span style={{ color:"rgba(26,24,20,0.88)", fontSize:"1rem", transform: open===i?"rotate(45deg)":"", transition:"transform 0.25s", flexShrink:0, marginLeft:"1rem" }}>+</span>
              </div>
              {open === i && (
                <div style={{ padding:"0 1.25rem 1.25rem", fontSize:"0.85rem", color:"rgba(26,24,20,0.84)", lineHeight:1.7, fontWeight:300, borderTop:"1px solid rgba(26,24,20,0.14)", paddingTop:"1rem" }}>
                  {f.a}
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
 
/* ─── CTA ───────────────────────────────────────────────────────────────── */
function CTA() {
  return (
    <section style={{ background:"#edeae4", padding:"7rem 1.5rem 8rem" }}>
      <div style={{ maxWidth:"42rem", margin:"0 auto", textAlign:"center" }}>
        <div className="reveal">
          <span className="section-badge">Get Started</span>
          <h2 className="serif-italic" style={{ fontSize:"clamp(2.5rem,6vw,4rem)", lineHeight:0.92, letterSpacing:"-0.04em", margin:"0 0 1.25rem", fontWeight:400 }}>
            Your car deserves<br />a real bidding war.
          </h2>
          <p style={{ color:"rgba(26,24,20,0.84)", fontSize:"1rem", maxWidth:400, margin:"0 auto 2.25rem", fontWeight:300 }}>
            List in 3 minutes. Watch dealers compete. Walk away with more than you expected.
          </p>
          <div style={{ display:"flex", gap:"0.75rem", justifyContent:"center", flexWrap:"wrap" }}>
            <button className="lg-strong" onClick={() => window.location.href='/app?role=seller'} style={{ borderRadius:"9999px", padding:"0.9rem 2rem", fontSize:"0.95rem", color:"#f5f3ef", border:"none", cursor:"pointer", fontFamily:"Barlow, sans-serif", fontWeight:500, display:"flex", alignItems:"center", gap:"0.4rem" }}>
              List My Car Free ↗
            </button>
            <button className="lg" onClick={() => window.location.href='/app?role=dealer'} style={{ borderRadius:"9999px", padding:"0.9rem 1.75rem", fontSize:"0.95rem", color:"rgba(26,24,20,0.88)", border:"1px solid rgba(26,24,20,0.12)", cursor:"pointer", fontFamily:"Barlow, sans-serif", fontWeight:300, background:"rgba(255,255,255,0.4)" }}>
              Dealer Access →
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
 
/* ─── FOOTER ────────────────────────────────────────────────────────────── */
function Footer() {
  return (
    <footer style={{ background:"#edeae4", padding:"0 1.5rem 2.5rem" }}>
      <div style={{ maxWidth:"64rem", margin:"0 auto" }}>
        <div style={{ height:"1px", background:"rgba(26,24,20,0.10)", marginBottom:"2rem" }} />
        <div style={{ display:"flex", justifyContent:"space-between", alignItems:"center", flexWrap:"wrap", gap:"1rem" }}>
          <div>
            <span className="serif-italic" style={{ fontSize:"1.1rem", color:"rgba(26,24,20,0.80)" }}>
              Priva<span style={{ color:"var(--accent)" }}>Buy</span>
            </span>
            <div style={{ fontSize:"0.72rem", color:"rgba(26,24,20,0.88)", marginTop:"0.3rem" }}>© 2026 PrivaBuy. All rights reserved.</div>
          </div>
          <div style={{ display:"flex", gap:"1.5rem" }}>
            {["Privacy","Terms","For Dealers","Contact"].map(l => (
              <a key={l} href="#" style={{ fontSize:"0.75rem", color:"rgba(26,24,20,0.88)", textDecoration:"none", transition:"color 0.2s" }}
                onMouseEnter={e=>e.target.style.color="rgba(26,24,20,0.75)"} onMouseLeave={e=>e.target.style.color="rgba(26,24,20,0.56)"}>
                {l}
              </a>
            ))}
          </div>
        </div>
      </div>
    </footer>
  );
}
 
/* ─── APP ───────────────────────────────────────────────────────────────── */
export default function App() {
  useReveal();
  return (
    <>
      <FontLink />
      <div className="grain" />
      <Navbar />
      <Hero />
      <HowItWorks />
      <ForSellers />
      <ForDealers />
      <FAQ />
      <CTA />
      <Footer />
    </>
  );
}