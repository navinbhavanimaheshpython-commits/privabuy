import { useState, useRef, useEffect } from "react";

const PRIVABUY_SYSTEM_PROMPT = `You are PrivaBuy's 24/7 support assistant. PrivaBuy is a two-sided vehicle auction marketplace that connects private sellers of used vehicles (typically 6–8 year old, higher-mileage cars) with franchised dealerships through real-time competitive auctions.

You know everything about how PrivaBuy works for both sellers and dealers. Be concise, friendly, and direct. Never make up information you don't know — say "I'll connect you with our team for that" instead.

## FOR SELLERS:
- How it works: List your car → dealers bid in a live auction → you accept the best offer
- Minimum floor price: You set a minimum price. If no one bids above it, you don't have to sell.
- No take-backs: Once your listing is submitted to auction, it cannot be pulled. Once it goes into the system, it's final.
- E-Signature required before sending to auction
- You must disclose all known issues with the vehicle — any deception can result in the dealer returning the car
- No buyer fee for dealers means more dealers bid, which means better prices for you
- Platform fee: $250 for sellers (paid via Stripe)
- You'll get real competing bids from multiple franchised dealers
- New way to sell: Better than Carvana, better than selling to a single dealership

## FOR DEALERS:
- No buy fee — zero cost to bid, you only pay when you win
- Platform fee: $600 for dealers (paid via Stripe)
- 24-hour rejection window: After winning, dealers have 24 hours to reject the vehicle IF there are undisclosed issues or deception. This is the only valid return reason.
- Do NOT accept leased vehicles — excluded entirely
- If a leased vehicle is submitted, the lien holder and financing factor must be identified, and the seller must pay any difference if they owe more than the auction price
- Sellers must provide a 10-day payoff statement if applicable
- E-Signature required: if no title, seller must disclose
- Frontline Ready vehicles preferred
- Dealers must feel good about the deal — the platform is built around dealer trust

## GENERAL:
- PrivaBuy created a market that didn't exist before — private seller supply going directly to franchised dealers
- None of PrivaBuy's competition offers this model
- AI bot line + online chatroom + phone support available
- Pilot program: no charges during early access phase
- Patent/patenting in progress
- For complex questions, direct users to register online or call the PrivaBuy team

Keep answers under 4 sentences unless the question requires more detail. Always be warm and confident.`;

const MessageBubble = ({ msg }) => {
  const isUser = msg.role === "user";
  return (
    <div
      style={{
        display: "flex",
        justifyContent: isUser ? "flex-end" : "flex-start",
        marginBottom: "10px",
      }}
    >
      {!isUser && (
        <div
          style={{
            width: 28,
            height: 28,
            borderRadius: "50%",
            background: "linear-gradient(135deg, #c9b8ff, #a8f0e0)",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            fontSize: 13,
            flexShrink: 0,
            marginRight: 8,
            marginTop: 2,
          }}
        >
          P
        </div>
      )}
      <div
        style={{
          maxWidth: "78%",
          padding: "10px 14px",
          borderRadius: isUser ? "18px 18px 4px 18px" : "18px 18px 18px 4px",
          background: isUser
            ? "linear-gradient(135deg, #c9b8ff 0%, #a8a0f0 100%)"
            : "rgba(255,255,255,0.07)",
          border: isUser ? "none" : "1px solid rgba(255,255,255,0.1)",
          color: isUser ? "#0a0a0a" : "#f0f0f0",
          fontSize: 13.5,
          lineHeight: 1.55,
          fontFamily: "'Inter', sans-serif",
          whiteSpace: "pre-wrap",
        }}
      >
        {msg.content}
      </div>
    </div>
  );
};

const TypingIndicator = () => (
  <div style={{ display: "flex", alignItems: "center", gap: 8, marginBottom: 10 }}>
    <div
      style={{
        width: 28,
        height: 28,
        borderRadius: "50%",
        background: "linear-gradient(135deg, #c9b8ff, #a8f0e0)",
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        fontSize: 13,
        flexShrink: 0,
      }}
    >
      P
    </div>
    <div
      style={{
        padding: "10px 16px",
        borderRadius: "18px 18px 18px 4px",
        background: "rgba(255,255,255,0.07)",
        border: "1px solid rgba(255,255,255,0.1)",
        display: "flex",
        gap: 5,
        alignItems: "center",
      }}
    >
      {[0, 1, 2].map((i) => (
        <div
          key={i}
          style={{
            width: 7,
            height: 7,
            borderRadius: "50%",
            background: "#c9b8ff",
            animation: "bounce 1.2s infinite",
            animationDelay: `${i * 0.2}s`,
          }}
        />
      ))}
    </div>
  </div>
);

export default function PrivaBuyChatbot() {
  const [open, setOpen] = useState(false);
  const [messages, setMessages] = useState([
    {
      role: "assistant",
      content:
        "Hey! I'm PrivaBuy's support bot — available 24/7. Ask me anything about selling your car, dealer bidding, auctions, fees, or how the platform works.",
    },
  ]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);
  const [pulse, setPulse] = useState(true);
  const bottomRef = useRef(null);
  const inputRef = useRef(null);

  useEffect(() => {
    if (open) {
      setTimeout(() => inputRef.current?.focus(), 300);
      setPulse(false);
    }
  }, [open]);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages, loading]);

  const sendMessage = async () => {
    const text = input.trim();
    if (!text || loading) return;
    setInput("");

    const newMessages = [...messages, { role: "user", content: text }];
    setMessages(newMessages);
    setLoading(true);

    try {
      const response = await fetch(`${import.meta.env.VITE_API_URL}/api/chat`, {
        method: "POST",
        headers: {
                 "Content-Type": "application/json",
                  },
        body: JSON.stringify({
          model: "claude-sonnet-4-6",
          max_tokens: 1000,
          system: PRIVABUY_SYSTEM_PROMPT,
          messages: newMessages.map((m) => ({
            role: m.role,
            content: m.content,
          })),
        }),
      });

      const data = await response.json();
      const reply =
        data.content?.find((b) => b.type === "text")?.text ||
        "I'm having trouble right now. Please call us or try again in a moment.";

      setMessages((prev) => [...prev, { role: "assistant", content: reply }]);
    } catch {
      setMessages((prev) => [
        ...prev,
        {
          role: "assistant",
          content:
            "Something went wrong on my end. Please try again or reach out to our team directly.",
        },
      ]);
    } finally {
      setLoading(false);
    }
  };

  const handleKey = (e) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  return (
    <>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap');

        @keyframes bounce {
          0%, 60%, 100% { transform: translateY(0); opacity: 0.4; }
          30% { transform: translateY(-5px); opacity: 1; }
        }
        @keyframes slideUp {
          from { opacity: 0; transform: translateY(20px) scale(0.97); }
          to { opacity: 1; transform: translateY(0) scale(1); }
        }
        @keyframes pulseRing {
          0% { box-shadow: 0 0 0 0 rgba(201,184,255,0.5); }
          70% { box-shadow: 0 0 0 12px rgba(201,184,255,0); }
          100% { box-shadow: 0 0 0 0 rgba(201,184,255,0); }
        }
        .pb-chat-input::placeholder { color: rgba(255,255,255,0.3); }
        .pb-chat-input:focus { outline: none; }
        .pb-send-btn:hover { background: #b8a5f0 !important; }
        .pb-close-btn:hover { background: rgba(255,255,255,0.1) !important; }
        .pb-quick-btn:hover { background: rgba(201,184,255,0.15) !important; border-color: #c9b8ff !important; }
      `}</style>

      {/* Floating Bubble */}
      <button
        onClick={() => setOpen((o) => !o)}
        style={{
          position: "fixed",
          bottom: 28,
          right: 28,
          width: 58,
          height: 58,
          borderRadius: "50%",
          background: "linear-gradient(135deg, #c9b8ff 0%, #a8a0f0 100%)",
          border: "none",
          cursor: "pointer",
          display: "flex",
          alignItems: "center",
          justifyContent: "center",
          boxShadow: "0 4px 24px rgba(201,184,255,0.4)",
          zIndex: 9999,
          animation: pulse ? "pulseRing 2s infinite" : "none",
          transition: "transform 0.2s",
        }}
        title="Chat with PrivaBuy Support"
      >
        {open ? (
          <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#0a0a0a" strokeWidth="2.5" strokeLinecap="round">
            <line x1="18" y1="6" x2="6" y2="18" />
            <line x1="6" y1="6" x2="18" y2="18" />
          </svg>
        ) : (
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#0a0a0a" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
          </svg>
        )}
      </button>

      {/* Chat Window */}
      {open && (
        <div
          style={{
            position: "fixed",
            bottom: 98,
            right: 28,
            width: 360,
            height: 520,
            background: "#0f0f0f",
            borderRadius: 20,
            border: "1px solid rgba(255,255,255,0.1)",
            boxShadow: "0 24px 80px rgba(0,0,0,0.7), 0 0 0 1px rgba(201,184,255,0.08)",
            display: "flex",
            flexDirection: "column",
            overflow: "hidden",
            zIndex: 9998,
            animation: "slideUp 0.25s ease",
            fontFamily: "'Inter', sans-serif",
          }}
        >
          {/* Header */}
          <div
            style={{
              padding: "16px 18px",
              borderBottom: "1px solid rgba(255,255,255,0.08)",
              background: "rgba(201,184,255,0.05)",
              display: "flex",
              alignItems: "center",
              gap: 12,
            }}
          >
            <div
              style={{
                width: 36,
                height: 36,
                borderRadius: "50%",
                background: "linear-gradient(135deg, #c9b8ff, #a8f0e0)",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                fontSize: 15,
                fontWeight: 700,
                color: "#0a0a0a",
              }}
            >
              P
            </div>
            <div>
              <div style={{ color: "#fff", fontWeight: 600, fontSize: 14 }}>PrivaBuy Support</div>
              <div style={{ color: "#a8f0e0", fontSize: 11, display: "flex", alignItems: "center", gap: 5 }}>
                <span style={{ width: 6, height: 6, borderRadius: "50%", background: "#a8f0e0", display: "inline-block" }} />
                Online 24/7
              </div>
            </div>
          </div>

          {/* Messages */}
          <div
            style={{
              flex: 1,
              overflowY: "auto",
              padding: "16px 14px",
              scrollbarWidth: "thin",
              scrollbarColor: "rgba(255,255,255,0.1) transparent",
            }}
          >
            {messages.map((msg, i) => (
              <MessageBubble key={i} msg={msg} />
            ))}
            {loading && <TypingIndicator />}
            <div ref={bottomRef} />
          </div>

          {/* Quick Prompts — only show at start */}
          {messages.length === 1 && (
            <div style={{ padding: "0 14px 10px", display: "flex", flexWrap: "wrap", gap: 6 }}>
              {["How does selling work?", "Dealer fees?", "Can I pull my listing?", "What cars qualify?"].map((q) => (
                <button
                  key={q}
                  className="pb-quick-btn"
                  onClick={() => { setInput(q); setTimeout(() => sendMessage(), 50); setInput(q); }}
                  style={{
                    background: "transparent",
                    border: "1px solid rgba(201,184,255,0.3)",
                    borderRadius: 20,
                    color: "#c9b8ff",
                    fontSize: 11.5,
                    padding: "5px 11px",
                    cursor: "pointer",
                    fontFamily: "'Inter', sans-serif",
                    transition: "all 0.15s",
                  }}
                >
                  {q}
                </button>
              ))}
            </div>
          )}

          {/* Input */}
          <div
            style={{
              padding: "12px 14px",
              borderTop: "1px solid rgba(255,255,255,0.08)",
              display: "flex",
              gap: 8,
              alignItems: "flex-end",
            }}
          >
            <textarea
              ref={inputRef}
              className="pb-chat-input"
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={handleKey}
              placeholder="Ask anything about PrivaBuy..."
              rows={1}
              style={{
                flex: 1,
                background: "rgba(255,255,255,0.06)",
                border: "1px solid rgba(255,255,255,0.1)",
                borderRadius: 12,
                color: "#f0f0f0",
                fontSize: 13.5,
                padding: "10px 13px",
                resize: "none",
                fontFamily: "'Inter', sans-serif",
                lineHeight: 1.4,
                maxHeight: 90,
                overflow: "auto",
              }}
            />
            <button
              className="pb-send-btn"
              onClick={sendMessage}
              disabled={loading || !input.trim()}
              style={{
                width: 38,
                height: 38,
                borderRadius: 12,
                background: input.trim() && !loading ? "#c9b8ff" : "rgba(255,255,255,0.08)",
                border: "none",
                cursor: input.trim() && !loading ? "pointer" : "not-allowed",
                display: "flex",
                alignItems: "center",
                justifyContent: "center",
                flexShrink: 0,
                transition: "all 0.15s",
              }}
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={input.trim() && !loading ? "#0a0a0a" : "#555"} strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <line x1="22" y1="2" x2="11" y2="13" />
                <polygon points="22 2 15 22 11 13 2 9 22 2" />
              </svg>
            </button>
          </div>
        </div>
      )}
    </>
  );
}
