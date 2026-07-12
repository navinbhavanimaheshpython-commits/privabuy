--
-- PostgreSQL database dump
--

\restrict Y0r27s22xWZioV5kYHFmLIGguFbily7Ywld0GOhzx9Cy2CIbKgJnnK6RFaXydDb

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg13+1)
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_settings (
    key text NOT NULL,
    value text NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: cars; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cars (
    car_id uuid CONSTRAINT cars_id_not_null NOT NULL,
    seller_id uuid,
    year integer,
    make character varying(100),
    model character varying(100),
    mileage integer,
    zip character varying(10),
    condition character varying(100),
    seller_phone character varying(20),
    seller_email character varying(255),
    created_at timestamp without time zone,
    status character varying(50),
    vin character varying(17),
    title_status character varying(50) DEFAULT 'Clean'::character varying,
    loan_status character varying(50) DEFAULT 'None'::character varying,
    "trim" character varying(50),
    color character varying(50),
    transmission character varying(50),
    drivetrain character varying(50),
    keys character varying(10),
    accidents character varying(20) DEFAULT 'None'::character varying,
    owners integer DEFAULT 1,
    smoked_in boolean DEFAULT false,
    overall_condition character varying(50),
    comments text,
    addons text,
    photos jsonb DEFAULT '[]'::jsonb,
    floor_price integer DEFAULT 0,
    lien_holder text,
    lien_payoff_amount integer DEFAULT 0,
    lien_payoff_url text,
    has_accident boolean DEFAULT false,
    vinaudit_accidents integer DEFAULT 0
);


--
-- Name: dealer_car_connections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dealer_car_connections (
    id uuid NOT NULL,
    car_id uuid,
    dealer_id uuid,
    created_at timestamp without time zone
);


--
-- Name: dealer_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dealer_notifications (
    id uuid NOT NULL,
    dealer_id uuid,
    car_id uuid,
    type character varying(100),
    created_at timestamp without time zone,
    sent boolean DEFAULT false
);


--
-- Name: dealers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dealers (
    id uuid NOT NULL,
    dealer_name character varying(255),
    contact_name character varying(255),
    phone character varying(20),
    email character varying(255),
    city character varying(100),
    state character varying(50),
    api_key character varying(50),
    created_at timestamp without time zone,
    license_number character varying(50),
    status character varying(20) DEFAULT 'approved'::character varying
);


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invoices (
    invoice_id text DEFAULT (gen_random_uuid())::text NOT NULL,
    invoice_number text NOT NULL,
    transaction_id text NOT NULL,
    dealer_id text NOT NULL,
    dealer_email text NOT NULL,
    dealer_name text NOT NULL,
    vehicle text NOT NULL,
    win_price numeric NOT NULL,
    amount numeric NOT NULL,
    status text DEFAULT 'unpaid'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    paid_at timestamp with time zone
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offers (
    id uuid NOT NULL,
    dealer_id uuid,
    car_id uuid,
    offer_amount integer,
    status character varying(50),
    created_at timestamp without time zone
);


--
-- Name: pending_sellers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pending_sellers (
    id integer NOT NULL,
    name text,
    phone text,
    email text,
    year text,
    make text,
    model text,
    mileage text,
    condition text,
    prefill_token text,
    source text DEFAULT 'meta_lead_form'::text,
    status text DEFAULT 'pending'::text,
    created_at timestamp without time zone DEFAULT now(),
    meta_leadgen_id text
);


--
-- Name: pending_sellers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pending_sellers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pending_sellers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pending_sellers_id_seq OWNED BY public.pending_sellers.id;


--
-- Name: sellers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sellers (
    id uuid NOT NULL,
    phone character varying(20),
    email character varying(255),
    created_at timestamp without time zone,
    password character varying(255),
    name character varying(100),
    reset_token character varying(255),
    reset_token_expires timestamp without time zone
);


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    transaction_id text NOT NULL,
    offer_id text NOT NULL,
    car_id text NOT NULL,
    dealer_id text NOT NULL,
    seller_id text NOT NULL,
    amount numeric(10,2) NOT NULL,
    status text DEFAULT 'awaiting_dealer_payment'::text NOT NULL,
    dealer_payment_deadline timestamp without time zone,
    dealer_fee_paid boolean DEFAULT false,
    dealer_paid_at timestamp without time zone,
    bill_of_sale_dealer_acked boolean DEFAULT false,
    bill_of_sale_seller_acked boolean DEFAULT false,
    dealer_acked_at timestamp without time zone,
    seller_acked_at timestamp without time zone,
    pickup_slot_1 text,
    pickup_slot_2 text,
    pickup_slot_3 text,
    slots_proposed_at timestamp without time zone,
    confirmed_pickup_slot text,
    slot_confirmed_at timestamp without time zone,
    pickup_confirmed boolean DEFAULT false,
    pickup_confirmed_at timestamp without time zone,
    vehicle_as_described boolean,
    discrepancy_note text,
    seller_payment_confirmed boolean DEFAULT false,
    seller_payment_confirmed_at timestamp without time zone,
    seller_fee_paid boolean DEFAULT false,
    seller_paid_at timestamp without time zone,
    completed_at timestamp without time zone,
    forfeited_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now(),
    inspection_deadline timestamp without time zone,
    inspection_reject_reason text,
    inspection_accepted_at timestamp without time zone,
    inspection_rejected_at timestamp without time zone,
    dispute_evidence_urls text[],
    dispute_category text,
    dispute_submitted_at timestamp without time zone,
    refund_status text DEFAULT 'none'::text,
    refund_issued_at timestamp without time zone,
    has_accident boolean DEFAULT false,
    pre_dispute_status character varying(100),
    resume_status character varying(100),
    resolved_at timestamp without time zone,
    title_confirmed_at timestamp without time zone,
    title_photo_url text,
    title_confirmed_by text
);


--
-- Name: pending_sellers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_sellers ALTER COLUMN id SET DEFAULT nextval('public.pending_sellers_id_seq'::regclass);


--
-- Data for Name: app_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_settings (key, value, updated_at) FROM stdin;
clean_data_cutoff	2026-06-30 18:29:49.056175+00	2026-06-30 18:29:49.056175+00
\.


--
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.cars (car_id, seller_id, year, make, model, mileage, zip, condition, seller_phone, seller_email, created_at, status, vin, title_status, loan_status, "trim", color, transmission, drivetrain, keys, accidents, owners, smoked_in, overall_condition, comments, addons, photos, floor_price, lien_holder, lien_payoff_amount, lien_payoff_url, has_accident, vinaudit_accidents) FROM stdin;
ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	8b66bb6c-3e18-43d1-8069-886a4d79e3b7	2017	Buick	Lacrosse	88888	46835	like-new		gearloom.ai@gmail.com	2026-06-05 23:12:07.300202	accepted_pending_settlement	1G4ZR5SS0HU158220	Clean	None	Premium	White	Automatic	FWD	Yes	None	1	f	Like New		None	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780701079/jdq4zfooluznxaj6ykuh.png", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780701082/d6xzcbpgewavtiny2dmy.png", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780701083/yacraaeyk6d8g0wvixst.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780701085/dt8hfhq1xanetggbwvm4.png", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780701087/p4yosmwgzckkwu0dd5qt.png", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780701087/ibpgrka27z4tuck6tgb3.png", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780701088/pexngdrhlx1x6kx7stgx.png", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780701091/yonvnogsvcod3k43xoj3.png", "label": "Any Damage"}]	14161		0		f	0
ce771810-7ec0-4206-8aec-f30e24ee000f	680997c1-4874-444a-95d1-529038169cf4	2017	Buick	Lacrosse	99999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-07 21:38:02.0438	accepted_pending_settlement	1G4ZR5SS0HU158220	Clean	None	Premium	Silver	Automatic	FWD	Yes	None	1	f	Like New		None	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780868229/jv7uhgyqhxdhemrkej92.png", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780868233/sfulexgamwudh0ejshp0.png", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780868235/tx35ybsxgg1iysy2iiuk.png", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780868237/bue4i3ymhb8fdmmckkgr.png", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780868238/u1betfhmjz9dyipol3wv.png", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780868247/ybmqqznzszgtx3xjoumr.png", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780868252/ujrje5dysvlmcjaibwfr.png", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780868254/k1fdl9eszwa8xvhbm2kl.png", "label": "Any Damage"}]	13559		0		f	0
512cabe7-005c-4b91-b49c-1a39ceefb5f2	680997c1-4874-444a-95d1-529038169cf4	2017	Buick	Lacrosse	88888	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-08 23:04:20.054531	accepted_pending_settlement	1G4ZR5SS0HU158220	Clean	None	Premium	Obsidian Blue	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780959802/pncok7upkzhanlxrsbhn.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780959805/ezpjsxqsis0dlka4j2i9.jpg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780959807/hbd18lbobgpuhnogdehk.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780959811/vi3mvawsmp3vmimlfzww.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780959813/uubxqu8fqfhi6lldqavo.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780959822/twd4wpobpfdbhdoilt0x.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780959824/bxik0v5aj58mzeujrnbl.jpg", "label": "Any Damage"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780959824/ad3oqsbq4yeebgmwlmoj.jpg", "label": "Odometer"}]	13559		0		f	0
b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	680997c1-4874-444a-95d1-529038169cf4	2021	Honda	Accord	99997	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-08 01:59:24.950936	accepted_pending_settlement	1HGCV3F94MA006942	Clean	None	Hybrid Touring	Silver	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780883914/gtr3jky5kbtld9lgct4j.png", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780883916/ryaeklynmfzpriiflvgq.png", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780883919/ez6smlgcuko6ndnouzuq.png", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780883922/atgkkkcojyytzsxqx3cs.png", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780883923/oguk0yvf0g52q8j6rjcp.png", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780883928/pvxiqflqgovlrfmwczuh.png", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780883930/lhogybxs0tm9fjlltewe.png", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780883933/drn8vx0jmhyvidn43g3h.png", "label": "Any Damage"}]	20384		0		f	0
7918e060-5fc1-4977-b0f0-d909ac7aa4a7	680997c1-4874-444a-95d1-529038169cf4	2021	Honda	Accord	99999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-09 01:21:37.509094	accepted_pending_settlement	1HGCV3F94MA006942	Clean	None	Hybrid Touring	White	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780967936/z1p0yquqyl61a5bcdthu.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780967953/ne8rhjufae7xtto4kcqy.jpg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780967960/jbhdrioe4xx2agte8y3s.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780967961/rg5fdivfdw6krlbiepup.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780967966/ofckgujxr6lfueyiyonl.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780967967/aymoriddsb7df5hxr4nf.jpg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780967979/qfjksggnqbzh0fp6jwer.jpg", "label": "Any Damage"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780967980/umg5txyaipzfdvzxuh4u.jpg", "label": "Engine Bay"}]	20384		0		f	0
ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	680997c1-4874-444a-95d1-529038169cf4	2017	Buick	Lacrosse	99999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-09 01:38:53.871313	accepted_pending_settlement	1G4ZR5SS0HU158220	Clean	None	Premium	white	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780969075/al9zqpjouwmswx08xnvl.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780969078/kyez7jopo8lstjafggc7.jpg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780969082/rcxub4nsr5skkjgm1zwq.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780969088/fw2nkvqs4jxg3ewml1py.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780969090/qwohxxxel8f5yiie8gkk.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780969091/uye3tqzdvqkap3zujzum.svg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780969096/vxgb8op8pem7tsyysplz.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1780969098/mlhgnnvsyjjfvyi0ommz.jpg", "label": "Any Damage"}]	13559		0		f	0
76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	680997c1-4874-444a-95d1-529038169cf4	2021	Honda	Accord	99999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-09 22:11:42.967033	accepted_pending_settlement	1HGCV3F94MA006942	Clean	None	Hybrid Touring	Silver	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781042771/qafnmrliffwxvqynjkce.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781042772/v5uwx3jp4vfipihfpgpu.jpg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781042774/erkfv3yyf5talwn9m9ey.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781042777/xp7sccagynkmypmr9rca.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781042779/wacx8ondpfo5f1t1br6d.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781042782/ovkdifi1uysogsydeert.jpg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781042784/jo1k9e3vgrsi8awxqbw2.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781042787/zlduvpnml3p7tvcyfd0l.jpg", "label": "Any Damage"}]	20384		0		f	0
d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	680997c1-4874-444a-95d1-529038169cf4	2017	Buick	Lacrosse	99999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-10 00:05:42.050208	accepted_pending_settlement	1G4ZR5SS0HU158220	Clean	None	Premium	Silver	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781049843/ly99cn7fivqvmypmudlv.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781049844/x7p4slapxaajwo5qms74.jpg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781049846/ibkdka84kgna3mvsgvoz.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781049849/mykn0gbfx7c8ss6fmyvz.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781049851/bpxmvbltdcnrb02ebaod.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781049853/dsuaqsiqu2of1fmgwbor.jpg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781049856/pouncaxywb4ug2l5mkhl.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781049859/jjd3cvhfjiptqrw8ztxa.jpg", "label": "Any Damage"}]	13559		0		f	0
31eecd26-0c3d-48ae-bdc2-19f89274339c	680997c1-4874-444a-95d1-529038169cf4	2017	Buick	Lacrosse	99999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-10 01:27:53.553024	accepted_pending_settlement	1G4ZR5SS0HU158220	Clean	None	Premium	Blue	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781054814/eemokeqwh4xeoqesbkjc.svg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781054816/kxcprs5ekopbxzr0uary.jpg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781054817/dbv3hze9ukxhiwyeh2qz.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781054820/flhlfg8d9dtzukyvujdl.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781054823/oqqmbfmw4q92oqxi4ion.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781054825/iroe0coiluun6edjrb22.jpg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781054826/r8yopr8era571wwml9sg.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781054829/xjlmr8pxjpk95zgprcvf.jpg", "label": "Any Damage"}]	13559		0		f	0
9cb60658-69a9-4c9e-adec-69e86ccbf9d5	680997c1-4874-444a-95d1-529038169cf4	2021	Honda	Accord	99999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-10 07:36:11.979597	accepted_pending_settlement	1HGCV3F94MA006942	Clean	None	Hybrid Touring	White	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781069787/emtitpfz9fgnkxpuncc0.svg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781069789/zpmtrv6ufpzixk9ndws4.svg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781069793/n4yvtxuvpokzacbp4tvp.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781069797/oltviwkxg2w1ojia3kjf.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781069799/qdiynglu9oz6uyqe7yun.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781069802/d6g4ph8ecike9amtcmoo.jpg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781069806/clnjc8xaiddqgcgoj9lt.svg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781069809/tmtjma4gradothrsskqp.png", "label": "Any Damage"}]	20384		0		f	0
65f0b7a1-819b-4d83-a372-4e01a929c3c7	680997c1-4874-444a-95d1-529038169cf4	2021	Honda	Accord	888999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-10 09:09:57.193663	accepted_pending_settlement	1HGCV3F94MA006942	Clean	None	Hybrid Touring	Obsidian Blue	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781082508/khenaoozkmkhq2alpftx.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781082510/jr2va7chqy5gjvju7mjr.jpg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781082511/zv52fytf6lzzyaamtlhd.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781082514/wesck4knqvbgfr6or0wz.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781082516/izrw6r4yz6qh7ju2lbs4.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781082518/owhk90pk3uqbhroqbmmt.jpg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781082521/rwcxaa0fa1mky95oq5n9.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781082524/nt4djgj1htaasvufgsgp.jpg", "label": "Any Damage"}]	20384		0		f	0
b77726af-0931-473e-b26d-8d9d1eaa048e	680997c1-4874-444a-95d1-529038169cf4	2021	Honda	Accord	99999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-11 18:43:34.738783	accepted_pending_settlement	1HGCV3F94MA006942	Clean	None	Hybrid Touring	White	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781203355/qrqbgdcnoxbhwrh5mwmy.svg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781203356/eqplzhayf9cxiuecqljw.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781203358/anrebnj1tvvsphiiwicz.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781203360/woactrmr1bp8rr7umjo5.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781203363/j36ma8bquhla3xcggp8a.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781203366/ddtr3pjmwltkbteohfhd.jpg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781203370/g33gofmvvr83oogj5xvl.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781203373/lphujjixzkjaj1qtzmqw.jpg", "label": "Any Damage"}]	20384		0		f	0
1989c510-ce33-4732-a4d2-57925d3e495d	680997c1-4874-444a-95d1-529038169cf4	2021	Honda	Accord	808080	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-11 19:55:32.712997	accepted_pending_settlement	1HGCV3F94MA006942	Clean	None	Hybrid Touring	Obsidian Blue	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781207378/hxwcgbgropflbc2kg0k7.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781207381/nkdlno5mka3cnvdbryas.jpg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781207384/sghrrjtamadfl7nr6k37.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781207387/bvf0sambzrypefmsvgzi.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781207390/qp6npz9v428vcydwuwpg.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781207393/ohmr2qusa1uog7ijfejg.jpg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781207395/vyvcaoxo9ndx13p7zhkx.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781207397/yfbom8sutsuotxvktmwa.jpg", "label": "Any Damage"}]	20384		0		f	0
e8d6e856-62bc-442a-99e0-590229cb3720	680997c1-4874-444a-95d1-529038169cf4	2017	Buick	Lacrosse	99999	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-11 20:37:00.848613	accepted_pending_settlement	1G4ZR5SS0HU158220	Clean	None	Premium	white	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781209984/abixmwgkuixzlpwu8rtr.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781209984/jrsiwflrzwx0rj2jgudm.svg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781209989/fwcafdvrzltm4t371rim.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781210004/ficqtaphspmcrzg91ph3.svg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781210006/pnzl5xzoqbqs1fyjbtwf.svg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781210026/qm33tqetn2xy2v5wzeuh.svg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781210029/dsa1frcubqwrykmnti7c.svg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781210036/yb9rnl8cidalepqfaafl.png", "label": "Any Damage"}]	13559		0		f	0
b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	680997c1-4874-444a-95d1-529038169cf4	2021	Honda	Accord	99000	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-11 21:11:57.441779	accepted_pending_settlement	1HGCV3F94MA006942	Clean	None	Hybrid Touring	Silver	Automatic	FWD	Yes	None	1	f	Like New		None	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781212264/hozrwcxglqn9jcofygga.jpg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781212266/mkq86oh5ptbxbhbhslz2.jpg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781212268/ifvmwabfldfggo9acklm.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781212270/tolu2fcvql0p1wepsnes.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781212273/z9lzroblkzejimjkoxm0.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781212274/arilfa6tb2qnwf8tev7x.svg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781212277/psxrznvabz1pvlzxzsjy.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781212279/fdvloukxai6lzm684grc.jpg", "label": "Any Damage"}]	20384		0		f	0
ada5b88e-b9df-430e-b41f-3eea8de15fe8	680997c1-4874-444a-95d1-529038169cf4	2021	Honda	Accord	77888	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-11 21:41:37.837234	accepted_pending_settlement	1HGCV3F94MA006942	Clean	None	Hybrid Touring	Silver	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781213630/bmdumhyqlxx3cxdtw373.svg", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781213631/uukvgqyhzemmhbyhdt6z.svg", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781213634/h4inlhti39luzqjlckeo.jpg", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781213636/ndlsiqxnbaie5dbvybco.jpg", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781213638/zhkfe4kcrhiurloueprs.jpg", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781213639/gzjrdzhk3suqkdicgpzw.jpg", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781213642/z94imwmqqqyfdc6pn5ke.jpg", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781213644/yepottagfh3ng4iudmmi.jpg", "label": "Any Damage"}]	20384		0		f	0
f037af4e-c70f-460b-9c16-cd2db6d8017b	680997c1-4874-444a-95d1-529038169cf4	2017	Buick	Lacrosse	99900	46835	like-new		navinbhavanimahesh55@gmail.com	2026-06-11 22:00:25.724574	accepted_pending_settlement	1G4ZR5SS0HU158220	Clean	None	Premium	white	Automatic	FWD	Yes	None	1	f	Like New		N/A	[{"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781215171/cbhfyc75bzzvtkrv9tju.png", "label": "Front Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781215175/vxyzhm9lpzjpfhw2hkfr.png", "label": "Driver Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781215177/sv0j0ybshdkzr4cswzh9.png", "label": "Passenger Side"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781215180/s1jd2golsan319mjjbau.png", "label": "Interior / Dashboard"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781215180/olesli9uexuylr9cijja.png", "label": "Rear Exterior"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781215184/jxdqilbtnfaq1vo7rkos.png", "label": "Odometer"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781215185/dvt4dkjnz2hjtsvagkkd.png", "label": "Engine Bay"}, {"url": "https://res.cloudinary.com/dptom0qr7/image/upload/v1781215187/vcgynb0l5vwwpvkknhds.png", "label": "Any Damage"}]	13559		0		f	0
\.


--
-- Data for Name: dealer_car_connections; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dealer_car_connections (id, car_id, dealer_id, created_at) FROM stdin;
df9b7ad6-e07e-49fe-b26a-bf4770a1ff91	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-05 23:12:07.308372
b04b97e7-c70a-45a5-8e08-3ea8a8d8011d	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-05 23:12:07.441809
bbde7a58-35eb-43c7-bcc3-0bb151b611bc	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-05 23:12:07.545659
d53f7cc0-216b-4c51-90b8-1a3509bcc1f1	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-05 23:12:07.655289
96d22da8-17e6-4392-89d2-05377793bbcb	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-05 23:12:07.758137
8a7e209b-0d1d-4f46-abc3-a263bd2ceaa2	ce771810-7ec0-4206-8aec-f30e24ee000f	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-07 21:38:02.049635
36987d61-bd00-4c1c-ab3d-7ec948bb99ee	ce771810-7ec0-4206-8aec-f30e24ee000f	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-07 21:38:02.261203
42a5fbcd-6851-45c1-8be4-381c5917d985	ce771810-7ec0-4206-8aec-f30e24ee000f	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-07 21:38:02.434276
ad8a99a1-a390-4343-a708-27959d0dc35c	ce771810-7ec0-4206-8aec-f30e24ee000f	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-07 21:38:02.701189
29262471-689b-44f2-947e-d11447a554f9	ce771810-7ec0-4206-8aec-f30e24ee000f	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-07 21:38:02.868912
84c11d69-8096-4098-aa4d-bc0210a366de	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-08 01:59:24.953296
71ba71d4-a3ed-4690-84c4-3be229cf6d02	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-08 01:59:25.167599
26a0b691-466c-4389-98f3-f40cf8e87a99	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-08 01:59:25.337578
921aa87a-2722-40fe-8bc2-08d8ee9bbb7e	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-08 01:59:25.513016
3b8d66ba-e170-4674-85ff-2165711d6be6	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-08 01:59:25.677631
30379251-1ad0-4c72-a320-6aaa33f1fb1e	512cabe7-005c-4b91-b49c-1a39ceefb5f2	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-08 23:04:20.062505
8481aa80-12a5-4000-9329-039eb5de5823	512cabe7-005c-4b91-b49c-1a39ceefb5f2	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-08 23:04:20.278369
60b7d388-a07d-47b6-88be-08f40d3c783d	512cabe7-005c-4b91-b49c-1a39ceefb5f2	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-08 23:04:20.44495
e65dbb0c-daad-4783-99e5-26d6fc285f66	512cabe7-005c-4b91-b49c-1a39ceefb5f2	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-08 23:04:20.630103
76b85094-459d-4c1f-9cfb-ee9b467ff671	512cabe7-005c-4b91-b49c-1a39ceefb5f2	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-08 23:04:20.829138
cbea51a9-f2fe-4fd1-a496-bdad5f289562	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-09 01:21:37.516978
b237c81d-417d-4e04-ad62-f2551895d015	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-09 01:21:37.748409
9d8e5786-e3cc-4b7a-8a97-bac17d00199f	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-09 01:21:37.94328
8cbd95be-4a7f-4a0e-b5b2-51409dae5fcd	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-09 01:21:38.114396
d339b5af-b4c8-4935-9657-c9a8291e286b	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-09 01:21:38.301945
3e3bf2c6-b4c5-423a-83a4-dd569aada864	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-09 01:38:53.88118
d60d53d5-a1e3-45df-adba-88cce5397689	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-09 01:38:54.119578
ee033145-11bb-4b55-87a5-93999b74834a	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-09 01:38:54.3155
26fb27a5-4dcb-4a3c-bf58-9d453048d25f	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-09 01:38:54.532855
9dc53fb0-fd0b-4d45-aef3-4abc3c37ba9d	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-09 01:38:54.725372
215d7258-80a2-4c92-bd1b-796a365bc1fa	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-09 22:11:42.971227
cf477552-7dd6-4abc-852a-a7fecf80b2bb	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-09 22:11:43.24914
46998345-1392-4e14-a0a1-80c5a61ad51d	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-09 22:11:43.463356
831e595b-d104-4b8d-ac84-42ea66b76ae6	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-09 22:11:43.663915
3ea05c64-c522-4400-a4d7-435f363ddeb6	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-09 22:11:43.862652
c4596314-b364-4dd1-9fe6-1e2acedea529	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-10 00:05:42.055018
b71663f5-6a0f-49c6-909b-c6088d323c88	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-10 00:05:42.268549
80036c87-2416-4756-b23a-4a603330e56f	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-10 00:05:42.443959
01255a4e-9142-41b4-a762-3a7f9cd22df4	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-10 00:05:42.633208
3f857d5d-d6ef-418b-a88a-ce29a76cfae3	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-10 00:05:42.86019
7ce8e560-3db4-4c6e-a051-a29ae521a6d8	31eecd26-0c3d-48ae-bdc2-19f89274339c	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-10 01:27:53.561283
e50b8bfb-99fc-46bb-b2d6-0f52f8c85ef3	31eecd26-0c3d-48ae-bdc2-19f89274339c	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-10 01:27:53.79321
c7d5fe28-d927-424d-8156-de032b3990b4	31eecd26-0c3d-48ae-bdc2-19f89274339c	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-10 01:27:53.991605
c80112b0-60ed-4de2-a082-fb6d73a207a8	31eecd26-0c3d-48ae-bdc2-19f89274339c	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-10 01:27:54.174225
9e2056fd-9725-4bec-b228-ecf1232e42cd	31eecd26-0c3d-48ae-bdc2-19f89274339c	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-10 01:27:54.427018
fcc8bee8-f838-4b69-b8e7-f945593c44c8	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-10 05:37:28.568803
05270f39-6597-4525-b49c-e3ea90fb867d	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-10 05:37:28.769077
ffa4d994-eedd-481a-81e1-5fd6fc19a014	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-10 05:37:28.934324
31d477c9-e0d6-4366-b62d-b9fb5ef7242a	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-10 05:37:29.116922
a0222cb0-24b7-40f0-a02d-09bbdbb07476	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-10 05:37:29.32832
57e50e73-682e-4099-97d6-7ab2afe6ce98	65f0b7a1-819b-4d83-a372-4e01a929c3c7	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-10 09:09:57.201753
0dcc2dab-3474-4e1e-94eb-564f64116385	65f0b7a1-819b-4d83-a372-4e01a929c3c7	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-10 09:09:57.430701
3cce2e8d-ff34-4f43-b69f-18c1853b70fa	65f0b7a1-819b-4d83-a372-4e01a929c3c7	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-10 09:09:57.727316
36c09edb-f57f-44e3-ab35-c2a3f30e70bc	65f0b7a1-819b-4d83-a372-4e01a929c3c7	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-10 09:09:57.896268
8ac6798c-86b0-4b32-a9ce-eabf88d224fa	65f0b7a1-819b-4d83-a372-4e01a929c3c7	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-10 09:09:58.068218
92c0800d-27fb-45b6-b6d8-288a5201235a	b77726af-0931-473e-b26d-8d9d1eaa048e	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-11 18:43:34.746361
722ad621-1434-4dce-8874-6ff8fff0f04b	b77726af-0931-473e-b26d-8d9d1eaa048e	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-11 18:43:34.967762
debfbb7f-a198-4619-9c1f-d2fc4dc34d6a	b77726af-0931-473e-b26d-8d9d1eaa048e	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-11 18:43:35.185882
9696673f-d533-4bf9-aa35-db634aff3d06	b77726af-0931-473e-b26d-8d9d1eaa048e	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-11 18:43:35.401851
5c17458d-f8b3-4020-b5e5-6227b8a25d03	b77726af-0931-473e-b26d-8d9d1eaa048e	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-11 18:43:35.599188
501165e1-ec7f-4027-8a1a-1133cda46345	1989c510-ce33-4732-a4d2-57925d3e495d	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-11 19:55:32.7206
2df8ad25-7517-48ff-b143-f87b5583c12a	1989c510-ce33-4732-a4d2-57925d3e495d	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-11 19:55:32.938539
d77ced39-a801-4927-abed-70864f4e16fb	1989c510-ce33-4732-a4d2-57925d3e495d	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-11 19:55:33.134096
1a303c0a-5307-4f4f-8aab-83bfa2e72133	1989c510-ce33-4732-a4d2-57925d3e495d	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-11 19:55:33.338469
ae199db5-3153-4970-924a-dcc9c7b992b2	1989c510-ce33-4732-a4d2-57925d3e495d	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-11 19:55:33.571214
e6afb8b1-80f6-4c95-809a-3d5788e01eff	e8d6e856-62bc-442a-99e0-590229cb3720	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-11 20:37:00.856506
be808bfe-e713-41e8-b223-457268136c10	e8d6e856-62bc-442a-99e0-590229cb3720	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-11 20:37:01.179069
b08ee5b8-b200-484a-bdf6-dbe6a5029a0b	e8d6e856-62bc-442a-99e0-590229cb3720	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-11 20:37:01.35981
81cf637d-0cfa-4627-b2f6-b77488f4c2c7	e8d6e856-62bc-442a-99e0-590229cb3720	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-11 20:37:01.5407
31a85d86-f577-4575-bbaf-7062b9709a82	e8d6e856-62bc-442a-99e0-590229cb3720	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-11 20:37:01.708156
56de705b-f2e8-46b7-9b9d-4f8884805972	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-11 21:11:57.450696
805cfbf1-5641-4563-be11-6e7f6c923154	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-11 21:11:57.697548
85f94273-ecb8-4255-af9d-2061b38b3adb	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-11 21:11:58.052581
e64f6ad6-0dc3-4dbd-99bb-5efb2546721b	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-11 21:11:58.231372
7148517b-7af9-4182-8239-716996867049	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-11 21:11:58.44176
3fbe0afa-7937-414d-9b7a-08acfb7f45fd	ada5b88e-b9df-430e-b41f-3eea8de15fe8	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-11 21:41:37.845415
df172560-ffd6-459b-896a-fce3344bb4ce	ada5b88e-b9df-430e-b41f-3eea8de15fe8	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-11 21:41:38.094632
6838b292-1a5a-4784-949d-d006b8a35877	ada5b88e-b9df-430e-b41f-3eea8de15fe8	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-11 21:41:38.309525
1af287c1-f62e-4e18-9c0a-2cec95db2d42	ada5b88e-b9df-430e-b41f-3eea8de15fe8	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-11 21:41:38.505101
6756b451-8877-4674-8e26-7749cd6bcb90	ada5b88e-b9df-430e-b41f-3eea8de15fe8	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-11 21:41:38.6928
0e79ae86-46c4-4637-9fe1-7575451f1dd9	f037af4e-c70f-460b-9c16-cd2db6d8017b	9334da13-ded4-4af6-809e-167d4a7f2440	2026-06-11 22:00:25.738178
4638c6a7-e2b7-4b42-92fa-c5cd259e4bb8	f037af4e-c70f-460b-9c16-cd2db6d8017b	1be7f46e-2b15-492b-9163-ef18c72885a3	2026-06-11 22:00:25.947312
6b9a6c5c-9a2f-4732-9af3-97ee2f2180d9	f037af4e-c70f-460b-9c16-cd2db6d8017b	15a09d87-9f82-4c77-a810-32d0b3d0652f	2026-06-11 22:00:26.14201
1ded2a06-5faf-410f-9f0d-5e2270768e9a	f037af4e-c70f-460b-9c16-cd2db6d8017b	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	2026-06-11 22:00:26.377352
6e466918-380a-4a20-93fc-ba7544e44f40	f037af4e-c70f-460b-9c16-cd2db6d8017b	d41846ec-416a-4849-8a90-2fc4f84a26ad	2026-06-11 22:00:26.569169
\.


--
-- Data for Name: dealer_notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dealer_notifications (id, dealer_id, car_id, type, created_at, sent) FROM stdin;
5cb50f98-2c40-4287-9e66-558b1c7dd1e4	9334da13-ded4-4af6-809e-167d4a7f2440	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	NEW_CAR_ASSIGNED	2026-06-05 23:12:07.310924	f
9950dba0-1103-4470-b6e9-36e966e965ca	1be7f46e-2b15-492b-9163-ef18c72885a3	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	NEW_CAR_ASSIGNED	2026-06-05 23:12:07.444881	f
0b859660-0b09-409e-94fc-1f48c194daa7	15a09d87-9f82-4c77-a810-32d0b3d0652f	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	NEW_CAR_ASSIGNED	2026-06-05 23:12:07.5487	f
b80a93ba-1bbd-4151-b5fd-ff38374e6cbc	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	NEW_CAR_ASSIGNED	2026-06-05 23:12:07.657957	f
5c1f404a-2025-44b3-91fb-6f734e6dbcc9	d41846ec-416a-4849-8a90-2fc4f84a26ad	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	NEW_CAR_ASSIGNED	2026-06-05 23:12:07.760814	f
a7b2778e-f900-457a-96a7-ead2a3d01d3d	9334da13-ded4-4af6-809e-167d4a7f2440	ce771810-7ec0-4206-8aec-f30e24ee000f	NEW_CAR_ASSIGNED	2026-06-07 21:38:02.050323	f
7ee5372b-2fd0-4c4c-9527-5b5df2e67bd3	1be7f46e-2b15-492b-9163-ef18c72885a3	ce771810-7ec0-4206-8aec-f30e24ee000f	NEW_CAR_ASSIGNED	2026-06-07 21:38:02.26211	f
195f7c55-f6c7-4171-b20e-1de998a6e171	15a09d87-9f82-4c77-a810-32d0b3d0652f	ce771810-7ec0-4206-8aec-f30e24ee000f	NEW_CAR_ASSIGNED	2026-06-07 21:38:02.435668	f
d50ceb19-6164-4fa6-b27b-144cc732502c	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	ce771810-7ec0-4206-8aec-f30e24ee000f	NEW_CAR_ASSIGNED	2026-06-07 21:38:02.702445	f
2b78a97a-0ed2-478b-889f-eb0a73abdc1f	d41846ec-416a-4849-8a90-2fc4f84a26ad	ce771810-7ec0-4206-8aec-f30e24ee000f	NEW_CAR_ASSIGNED	2026-06-07 21:38:02.869865	f
1e6fa297-c1ec-4b93-9d7d-911c5ddec041	9334da13-ded4-4af6-809e-167d4a7f2440	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	NEW_CAR_ASSIGNED	2026-06-08 01:59:24.953884	f
58f62541-1d9e-47ac-9260-03ff6abdeebb	1be7f46e-2b15-492b-9163-ef18c72885a3	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	NEW_CAR_ASSIGNED	2026-06-08 01:59:25.168947	f
a8c17e3d-bd7c-4ef1-9b19-86eca1ec277f	15a09d87-9f82-4c77-a810-32d0b3d0652f	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	NEW_CAR_ASSIGNED	2026-06-08 01:59:25.338394	f
e1ad9f8d-1470-451e-8bf7-fa7602e0d938	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	NEW_CAR_ASSIGNED	2026-06-08 01:59:25.51391	f
dae4e9c0-f342-4bdb-a680-fd171febdc7b	d41846ec-416a-4849-8a90-2fc4f84a26ad	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	NEW_CAR_ASSIGNED	2026-06-08 01:59:25.678471	f
d20d3ffc-6ea8-4e6b-bf1f-6ac6f3601c94	9334da13-ded4-4af6-809e-167d4a7f2440	512cabe7-005c-4b91-b49c-1a39ceefb5f2	NEW_CAR_ASSIGNED	2026-06-08 23:04:20.065317	f
85715496-cb97-4d2f-af43-7a0b1708139c	1be7f46e-2b15-492b-9163-ef18c72885a3	512cabe7-005c-4b91-b49c-1a39ceefb5f2	NEW_CAR_ASSIGNED	2026-06-08 23:04:20.280978	f
eea19e52-6673-493f-bacb-dc3b0a566bd0	15a09d87-9f82-4c77-a810-32d0b3d0652f	512cabe7-005c-4b91-b49c-1a39ceefb5f2	NEW_CAR_ASSIGNED	2026-06-08 23:04:20.448503	f
31b8372c-39cb-458e-864c-36dc280ed4bf	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	512cabe7-005c-4b91-b49c-1a39ceefb5f2	NEW_CAR_ASSIGNED	2026-06-08 23:04:20.633047	f
ecec6cc4-fb2e-4f54-a50d-b31914125e9a	d41846ec-416a-4849-8a90-2fc4f84a26ad	512cabe7-005c-4b91-b49c-1a39ceefb5f2	NEW_CAR_ASSIGNED	2026-06-08 23:04:20.832202	f
c9068584-0ccb-4d8c-878b-0a2a02d884fb	9334da13-ded4-4af6-809e-167d4a7f2440	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	NEW_CAR_ASSIGNED	2026-06-09 01:21:37.519487	f
6149ac6b-605f-4c0e-823a-7c2bfb130e93	1be7f46e-2b15-492b-9163-ef18c72885a3	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	NEW_CAR_ASSIGNED	2026-06-09 01:21:37.751238	f
f8bf5f25-aca8-4e69-a87a-1bffc5bab48e	15a09d87-9f82-4c77-a810-32d0b3d0652f	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	NEW_CAR_ASSIGNED	2026-06-09 01:21:37.94598	f
e806ea7d-b654-4d82-973e-36b3403bbca6	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	NEW_CAR_ASSIGNED	2026-06-09 01:21:38.117122	f
4ad323ff-ba5b-48cd-abe4-62f54efb6237	d41846ec-416a-4849-8a90-2fc4f84a26ad	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	NEW_CAR_ASSIGNED	2026-06-09 01:21:38.305602	f
48e86aea-a30b-4b80-848e-86af16018467	9334da13-ded4-4af6-809e-167d4a7f2440	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	NEW_CAR_ASSIGNED	2026-06-09 01:38:53.883687	f
b3d3540c-116a-406a-a0d4-65a1a6e13f13	1be7f46e-2b15-492b-9163-ef18c72885a3	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	NEW_CAR_ASSIGNED	2026-06-09 01:38:54.122222	f
776c6f55-ec90-481d-863a-63eac8fe837b	15a09d87-9f82-4c77-a810-32d0b3d0652f	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	NEW_CAR_ASSIGNED	2026-06-09 01:38:54.318174	f
54c0cf66-1f2b-475c-be97-d792c607c702	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	NEW_CAR_ASSIGNED	2026-06-09 01:38:54.535576	f
95a9bc57-22d5-4053-b39d-ea7be2c29aa2	d41846ec-416a-4849-8a90-2fc4f84a26ad	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	NEW_CAR_ASSIGNED	2026-06-09 01:38:54.728323	f
96d541ff-83ca-4ed3-b12e-f870034fe6d7	9334da13-ded4-4af6-809e-167d4a7f2440	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	NEW_CAR_ASSIGNED	2026-06-09 22:11:42.972638	f
669accc2-99ed-4813-a918-52f174a13d20	1be7f46e-2b15-492b-9163-ef18c72885a3	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	NEW_CAR_ASSIGNED	2026-06-09 22:11:43.250641	f
96bd7b6e-89ec-4d3f-9bee-cd886798c45d	15a09d87-9f82-4c77-a810-32d0b3d0652f	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	NEW_CAR_ASSIGNED	2026-06-09 22:11:43.46504	f
6e0e831f-2099-4d5f-ad3b-2b958d772c53	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	NEW_CAR_ASSIGNED	2026-06-09 22:11:43.66554	f
8bac2801-d79e-4385-86d2-9ba487e6cff3	d41846ec-416a-4849-8a90-2fc4f84a26ad	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	NEW_CAR_ASSIGNED	2026-06-09 22:11:43.864178	f
77bb1dd5-d1d0-4d43-9671-c292f8ee1397	9334da13-ded4-4af6-809e-167d4a7f2440	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	NEW_CAR_ASSIGNED	2026-06-10 00:05:42.056344	f
645586da-887f-40a9-9ac9-4e50effde2f0	1be7f46e-2b15-492b-9163-ef18c72885a3	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	NEW_CAR_ASSIGNED	2026-06-10 00:05:42.269962	f
8d23ed78-1726-4027-9839-28bc061b9edd	15a09d87-9f82-4c77-a810-32d0b3d0652f	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	NEW_CAR_ASSIGNED	2026-06-10 00:05:42.445497	f
f7fc9ead-cb50-43fe-b728-853b478a2f2f	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	NEW_CAR_ASSIGNED	2026-06-10 00:05:42.634795	f
443881f1-04a6-4a81-b195-ad0ed3f04f06	d41846ec-416a-4849-8a90-2fc4f84a26ad	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	NEW_CAR_ASSIGNED	2026-06-10 00:05:42.861641	f
cf248ca6-a535-4fae-8028-48716ddb429b	9334da13-ded4-4af6-809e-167d4a7f2440	31eecd26-0c3d-48ae-bdc2-19f89274339c	NEW_CAR_ASSIGNED	2026-06-10 01:27:53.564134	f
e306869a-63bb-417a-b4d1-df8543a72c29	1be7f46e-2b15-492b-9163-ef18c72885a3	31eecd26-0c3d-48ae-bdc2-19f89274339c	NEW_CAR_ASSIGNED	2026-06-10 01:27:53.79588	f
f35ffd99-a7b4-4660-9eec-55d57cb7bf24	15a09d87-9f82-4c77-a810-32d0b3d0652f	31eecd26-0c3d-48ae-bdc2-19f89274339c	NEW_CAR_ASSIGNED	2026-06-10 01:27:53.994309	f
2985711b-bd1e-48c4-a9f9-8025b64da7d8	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	31eecd26-0c3d-48ae-bdc2-19f89274339c	NEW_CAR_ASSIGNED	2026-06-10 01:27:54.176828	f
5994e5fc-8e39-4611-a356-cfe913d5ff4a	d41846ec-416a-4849-8a90-2fc4f84a26ad	31eecd26-0c3d-48ae-bdc2-19f89274339c	NEW_CAR_ASSIGNED	2026-06-10 01:27:54.429727	f
2b6a7329-da63-4f0a-8e8b-8bf5081f661c	9334da13-ded4-4af6-809e-167d4a7f2440	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	NEW_CAR_ASSIGNED	2026-06-10 05:37:28.572443	f
f15c9845-7528-463e-ab73-a474678315d5	1be7f46e-2b15-492b-9163-ef18c72885a3	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	NEW_CAR_ASSIGNED	2026-06-10 05:37:28.771615	f
f70be5db-d8ed-4a8f-8776-5091cc8cb70e	15a09d87-9f82-4c77-a810-32d0b3d0652f	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	NEW_CAR_ASSIGNED	2026-06-10 05:37:28.936912	f
44fa6a56-4d26-45df-a30d-33f287d61aee	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	NEW_CAR_ASSIGNED	2026-06-10 05:37:29.119667	f
1af76661-aeb3-4113-99bb-52649f67d448	d41846ec-416a-4849-8a90-2fc4f84a26ad	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	NEW_CAR_ASSIGNED	2026-06-10 05:37:29.331128	f
fcf4c711-a470-41be-89fc-02810d67a9d3	9334da13-ded4-4af6-809e-167d4a7f2440	65f0b7a1-819b-4d83-a372-4e01a929c3c7	NEW_CAR_ASSIGNED	2026-06-10 09:09:57.204208	f
f02c0f5d-e6ca-4fa4-a30f-bb1b1f032bb5	1be7f46e-2b15-492b-9163-ef18c72885a3	65f0b7a1-819b-4d83-a372-4e01a929c3c7	NEW_CAR_ASSIGNED	2026-06-10 09:09:57.433193	f
d60f0aa8-269b-4615-a753-dfe934c95821	15a09d87-9f82-4c77-a810-32d0b3d0652f	65f0b7a1-819b-4d83-a372-4e01a929c3c7	NEW_CAR_ASSIGNED	2026-06-10 09:09:57.729874	f
21ff4871-72ec-4108-8f89-c2f57b0f71c3	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	65f0b7a1-819b-4d83-a372-4e01a929c3c7	NEW_CAR_ASSIGNED	2026-06-10 09:09:57.899025	f
261bbae3-597b-469c-92f5-9bdf086db8bd	d41846ec-416a-4849-8a90-2fc4f84a26ad	65f0b7a1-819b-4d83-a372-4e01a929c3c7	NEW_CAR_ASSIGNED	2026-06-10 09:09:58.070751	f
d0f28472-e36f-47a5-bcf5-cd02d0629e1a	9334da13-ded4-4af6-809e-167d4a7f2440	b77726af-0931-473e-b26d-8d9d1eaa048e	NEW_CAR_ASSIGNED	2026-06-11 18:43:34.748731	f
afee4d5c-bce1-4c31-a4a2-0be9ffdf9901	1be7f46e-2b15-492b-9163-ef18c72885a3	b77726af-0931-473e-b26d-8d9d1eaa048e	NEW_CAR_ASSIGNED	2026-06-11 18:43:34.970313	f
2597213d-01f3-4304-aa55-56ce12c35261	15a09d87-9f82-4c77-a810-32d0b3d0652f	b77726af-0931-473e-b26d-8d9d1eaa048e	NEW_CAR_ASSIGNED	2026-06-11 18:43:35.188447	f
dc9eba54-a2bb-4da0-9f3e-4cb23fd2de7d	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	b77726af-0931-473e-b26d-8d9d1eaa048e	NEW_CAR_ASSIGNED	2026-06-11 18:43:35.404346	f
756019ab-ea08-4fb5-9800-c342fcac534e	d41846ec-416a-4849-8a90-2fc4f84a26ad	b77726af-0931-473e-b26d-8d9d1eaa048e	NEW_CAR_ASSIGNED	2026-06-11 18:43:35.603053	f
38d978b4-7130-45b0-86c2-a735b228d27a	9334da13-ded4-4af6-809e-167d4a7f2440	1989c510-ce33-4732-a4d2-57925d3e495d	NEW_CAR_ASSIGNED	2026-06-11 19:55:32.722923	f
f8d4935e-45a3-4d55-ba30-05ca5103b2dc	1be7f46e-2b15-492b-9163-ef18c72885a3	1989c510-ce33-4732-a4d2-57925d3e495d	NEW_CAR_ASSIGNED	2026-06-11 19:55:32.941116	f
51a8fb52-752d-4f87-bd70-2e66f61da677	15a09d87-9f82-4c77-a810-32d0b3d0652f	1989c510-ce33-4732-a4d2-57925d3e495d	NEW_CAR_ASSIGNED	2026-06-11 19:55:33.136715	f
5b6ed050-9e37-4ed8-b4dc-886dfc8357a5	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	1989c510-ce33-4732-a4d2-57925d3e495d	NEW_CAR_ASSIGNED	2026-06-11 19:55:33.341275	f
1dabdca7-a778-4d8d-8258-d1a59d09d763	d41846ec-416a-4849-8a90-2fc4f84a26ad	1989c510-ce33-4732-a4d2-57925d3e495d	NEW_CAR_ASSIGNED	2026-06-11 19:55:33.573824	f
f621f860-e345-4b68-832d-97a59eaf2921	9334da13-ded4-4af6-809e-167d4a7f2440	e8d6e856-62bc-442a-99e0-590229cb3720	NEW_CAR_ASSIGNED	2026-06-11 20:37:00.859084	f
ab9ca644-aa75-421c-bd30-10f5e2466930	1be7f46e-2b15-492b-9163-ef18c72885a3	e8d6e856-62bc-442a-99e0-590229cb3720	NEW_CAR_ASSIGNED	2026-06-11 20:37:01.181786	f
2825f18d-927e-4c63-b0d4-50f235622a47	15a09d87-9f82-4c77-a810-32d0b3d0652f	e8d6e856-62bc-442a-99e0-590229cb3720	NEW_CAR_ASSIGNED	2026-06-11 20:37:01.362398	f
844ee914-6ed1-4d99-9198-30b451fca33a	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	e8d6e856-62bc-442a-99e0-590229cb3720	NEW_CAR_ASSIGNED	2026-06-11 20:37:01.543331	f
a2f0ed7e-f9fa-472e-ab56-63c83b52d60d	d41846ec-416a-4849-8a90-2fc4f84a26ad	e8d6e856-62bc-442a-99e0-590229cb3720	NEW_CAR_ASSIGNED	2026-06-11 20:37:01.711112	f
b241ee54-48fe-4399-a2e4-7a7e36a8490e	9334da13-ded4-4af6-809e-167d4a7f2440	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	NEW_CAR_ASSIGNED	2026-06-11 21:11:57.454071	f
3894122a-0b8a-4617-ab16-b2977b6b4fd9	1be7f46e-2b15-492b-9163-ef18c72885a3	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	NEW_CAR_ASSIGNED	2026-06-11 21:11:57.700315	f
7d765a1f-cf7c-489b-954f-75b4688515a2	15a09d87-9f82-4c77-a810-32d0b3d0652f	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	NEW_CAR_ASSIGNED	2026-06-11 21:11:58.055489	f
ac07a781-dd9e-4e49-8906-feb07f68e6af	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	NEW_CAR_ASSIGNED	2026-06-11 21:11:58.234819	f
775fe8de-d4a8-4051-8426-83275b17959e	d41846ec-416a-4849-8a90-2fc4f84a26ad	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	NEW_CAR_ASSIGNED	2026-06-11 21:11:58.446034	f
e6164db8-487f-4ab1-b2e4-35ced7bf536e	9334da13-ded4-4af6-809e-167d4a7f2440	ada5b88e-b9df-430e-b41f-3eea8de15fe8	NEW_CAR_ASSIGNED	2026-06-11 21:41:37.848003	f
2a7c4371-c74d-4486-94b1-668f616276bc	1be7f46e-2b15-492b-9163-ef18c72885a3	ada5b88e-b9df-430e-b41f-3eea8de15fe8	NEW_CAR_ASSIGNED	2026-06-11 21:41:38.097777	f
9a190f20-5f41-40e7-b1c7-29caca98e5ab	15a09d87-9f82-4c77-a810-32d0b3d0652f	ada5b88e-b9df-430e-b41f-3eea8de15fe8	NEW_CAR_ASSIGNED	2026-06-11 21:41:38.312579	f
631494c7-fc88-4442-a797-c9af36c95fe4	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	ada5b88e-b9df-430e-b41f-3eea8de15fe8	NEW_CAR_ASSIGNED	2026-06-11 21:41:38.507881	f
a05340eb-daac-4fd7-a08b-5e38f9ad4350	d41846ec-416a-4849-8a90-2fc4f84a26ad	ada5b88e-b9df-430e-b41f-3eea8de15fe8	NEW_CAR_ASSIGNED	2026-06-11 21:41:38.695585	f
89aad65a-1bb0-4d85-a995-9e5532778d18	9334da13-ded4-4af6-809e-167d4a7f2440	f037af4e-c70f-460b-9c16-cd2db6d8017b	NEW_CAR_ASSIGNED	2026-06-11 22:00:25.741487	f
66696268-ad80-4f16-8bcd-f44952d2f7d9	1be7f46e-2b15-492b-9163-ef18c72885a3	f037af4e-c70f-460b-9c16-cd2db6d8017b	NEW_CAR_ASSIGNED	2026-06-11 22:00:25.950521	f
ddc8fb91-b786-4222-821d-f82f13826046	15a09d87-9f82-4c77-a810-32d0b3d0652f	f037af4e-c70f-460b-9c16-cd2db6d8017b	NEW_CAR_ASSIGNED	2026-06-11 22:00:26.146786	f
ac01b819-e74f-4715-8a0b-43418b7ae542	1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	f037af4e-c70f-460b-9c16-cd2db6d8017b	NEW_CAR_ASSIGNED	2026-06-11 22:00:26.380409	f
00d95403-c1b2-41dc-9080-972f2632f967	d41846ec-416a-4849-8a90-2fc4f84a26ad	f037af4e-c70f-460b-9c16-cd2db6d8017b	NEW_CAR_ASSIGNED	2026-06-11 22:00:26.572857	f
\.


--
-- Data for Name: dealers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dealers (id, dealer_name, contact_name, phone, email, city, state, api_key, created_at, license_number, status) FROM stdin;
9334da13-ded4-4af6-809e-167d4a7f2440	Michea	Arkin	9292890668g	michealarkin@gmail.com	Socal	California	d321d7e9-4a1	2026-04-21 03:30:16.328465	\N	rejected
1be7f46e-2b15-492b-9163-ef18c72885a3	Northside Auto Group	Navin Test	3125550100	navinbhavanimaheshpython@gmail.com	Chicago	IL	69a2f400-cfd	2026-04-21 18:06:22.288469	IL-12345678	rejected
15a09d87-9f82-4c77-a810-32d0b3d0652f	Navin Bhavani Mahesh Python	Navin Bhavani Mahesh Python	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	58280c62-205	2026-04-30 06:57:50.187967	IL_12345678	rejected
1e40d432-3a12-4e1e-ac8c-6c1cc18d1154	Navin Bhavani Mahesh Python	Navin Bhavani Mahesh Python	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	6f610bb5-66f	2026-04-30 09:47:03.224478	IL-454545	rejected
d41846ec-416a-4849-8a90-2fc4f84a26ad	Bhavani Mahesh	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	f0098179-ce2	2026-05-21 16:50:57.339236	IN	rejected
85f01125-7699-47dd-87fb-4389b231f7ce	Bhavani Mahesh	Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	ee90984e-f55	2026-05-21 16:52:25.984081	IL-555555	rejected
3eb1b676-5f19-4e92-8e4c-ff5d4bcda9b1	Bhavani Auto Group	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	9a9717ef-064	2026-05-31 19:07:26.997487	IL-77777777	rejected
93668af4-0f91-4dd4-8a77-087683549559	Bhavani Mahesh Auto	Bhavani	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	eb12d2ef-1ca	2026-06-01 01:47:39.253709	IL- 55555555	rejected
98ca3305-fb48-4b19-9b87-438b856bde0d	Navin Bhavani Mahesh Auto	Navin Bhavani M	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	c44e6764-587	2026-06-01 01:48:54.905451	IL-33333333	rejected
b1e26e84-2d55-4289-9fb8-3538bc7a65c5	Tester Dealer One	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	e478c708-16d	2026-06-15 07:57:58.525118	IL-22222222	approved
295b1980-df46-4d7b-a30b-dae1b56d1d82	Fort Wayne Kia	robert pargeon	2602996015	rob.pargeon@rohrmanauto.com	Fort Wayne	IN	e39b9d3e-e61	2026-06-15 15:35:12.660645	2000489	approved
b42efccf-8046-471f-af47-aa207c931acf	Navin Bhavani Mahesh	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	92274275-3e3	2026-06-15 15:48:27.589538	IL_121212	rejected
cae12315-b8d8-4060-a074-8a2cbde61cbe	Northside Auto	Rick Stanley	3174097100	rick@rlstanley.com	Indianapolis	IN	dd83f9f7-367	2026-06-17 19:29:43.132774	2248329	approved
076b239c-9426-41b6-8295-eaf832f44d70	Midaway Motors	Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	48e7f724-0f9	2026-06-01 21:45:18.957739	IL-90909090	rejected
a86f72c2-1b69-4eaa-9f8f-85b2ab11499d	Tester Dealer Four	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	1468b460-37d	2026-06-19 10:23:10.409029	IL-4	rejected
d2951694-0bfc-406a-9011-4feea21b597a	Tester Dealer Three	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	6fd7d66b-64b	2026-06-19 10:15:34.330705	IL-2	rejected
efa13ff4-1ed3-4d3e-b95f-5d5eadc53242	Tester Dealer Two	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	8571e45b-5b4	2026-06-19 07:22:51.195394	Il-1	rejected
4ea0abcb-f5ba-4e6e-9130-471bdf3ccc96	Staging Testing Dealer	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	d97f895c-fca	2026-06-19 05:04:44.313171	IL- 555555	rejected
4fa63fcc-f062-44f4-a253-7b65a3d64f1b	Kelley Buick GMC	Trent Waybright	2602292284	twaybright@kelleyauto.com	Fort Wayne	IN	277317d5-693	2026-06-24 12:02:04.379647	1000927	approved
9f3cf371-8b61-4935-aba0-6377dd681b16	test Dealer 31	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	90e9d5db-85c	2026-06-22 12:53:36.883467	IL-31	rejected
9127c449-ccbc-4353-a640-b5cc873ea42c	Tester dealer 17	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	459264ec-29e	2026-06-22 08:59:49.592945	IL-17	rejected
c29a5494-52af-4338-8eaa-7fdd8026cb08	tester Dealer 30	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	34d8df54-9a1	2026-06-22 12:39:06.584618	IL-30	rejected
916e737d-894a-4c0a-a73d-b17e6eaccd70	Tester Dealer 19	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	a5a9f668-2d9	2026-06-22 09:33:43.144915	IL-19	rejected
8b00e6fd-849d-4fca-ac32-15214f69f7ec	Tester Dealer 18	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	23e43cc5-9c5	2026-06-22 09:06:26.785544	IL-18	rejected
07bd82e1-0dd1-47ce-a3a0-1e3cc585788d	Navin Bhavani Mahesh	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	8c6d0c90-392	2026-07-07 19:25:57.732769	IL-40	approved
d39cb577-93a5-481a-95e7-57b4c45a4a76	Tester Dealer 15	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	6d5d8d46-36f	2026-06-22 08:53:43.266569	IL-15	rejected
c72d6730-6e9e-4b84-b7fd-d4547ceaff65	Tester Dealer 14	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	98edbb6b-6ab	2026-06-22 08:25:45.303046	IL-14	rejected
3fd534cf-300d-49dc-8893-d3478a6876cc	Tester Dealer 13	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	401144b5-4a2	2026-06-22 08:13:47.696472	IL-13	rejected
7ef6753e-f7b1-4d63-82ca-274400cc0c88	Tester Dealer 12	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	cef311f2-491	2026-06-22 07:46:23.406093	IL-12	rejected
49221075-e6ae-4358-adcf-83fba7b7df45	Tester Dealer 11	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	696f5ac2-584	2026-06-22 07:45:03.460926	IL-11	rejected
aad3c27e-3f66-44bb-a98d-d0b18b2ce98a	Tester Dealer 10	Navin Bhavani Mahesh	9292890668	navinbhavanimahesh55@gmail.com	Fort Wayne	IN	dc44e30b-673	2026-06-22 07:34:50.921215	IL-10	rejected
99d44779-cdd5-4789-a950-b226c4609ca8	Tester Dealer Nine	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	ba36170d-722	2026-06-20 16:07:09.913048	IL-9	rejected
a2737bef-4468-4e37-bd8b-1169e69038a7	Tester Dealer Eight	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	6c23a065-25a	2026-06-20 10:39:41.669791	IL-8	rejected
5f3e1446-7af0-413b-8684-3524c730584b	Tester Dealer Seven	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	b1745fcf-419	2026-06-20 10:24:37.349686	IL-7	rejected
59183619-95ab-42e1-a754-572671e381a3	Tester Dealer Six	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	4b1db4e5-916	2026-06-20 02:30:44.546482	IL-6	rejected
6649be8a-0ad6-4f51-89ae-f242030e3062	Staging Testing Dealer No 5	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	db0ffc9e-b65	2026-06-19 12:16:03.245432	IL-5	rejected
5c949db1-4bb9-4d9b-b47b-94fdcdce45c2	Navin Bhavani Mahesh	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	0eb9d3dd-e3c	2026-06-22 08:54:29.45767	IL-16	approved
e8af6141-f08e-41c5-98f3-afc17e281ac9	Navin Bhavani Mahesh	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	cada1bb2-535	2026-06-19 00:21:29.966357	IL22222222	approved
9d006340-bdce-4817-aa5e-e209eb753c2c	Navin Bhavani Mahesh	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	7e027dfd-472	2026-06-30 13:18:49.030187	IL-35	approved
9477ed0c-6e36-443a-b6a1-9bdd23b0c807	Tester Dealer Michael	Michael Arkin	9292890668	TesterDealerMichael@gmail.com	Fort Wayne	IN	bd7ff755-9f6	2026-06-30 21:09:49.413842	1234567	approved
4fddd760-4fbb-4e07-8d30-b64e88fdf51d	Navin Bhavani Mahesh	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	8b43eca5-71f	2026-07-07 19:58:33.219176	IL-41	approved
f63c3884-bb02-49f3-aa41-3bb1174ff215	Navin Bhavani Mahesh	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	ed598ba4-eff	2026-07-07 21:01:28.499278	IL-42	approved
1569dc0b-7a45-4e90-91db-8d0af4b0ef56	Navin Bhavani Mahesh	Navin Bhavani Mahesh	9292890668	navinbhavanimaheshpython@gmail.com	Fort Wayne	IN	6dcb0f7d-8e7	2026-07-07 21:33:32.018082	IL-43	approved
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoices (invoice_id, invoice_number, transaction_id, dealer_id, dealer_email, dealer_name, vehicle, win_price, amount, status, created_at, paid_at) FROM stdin;
bd7dd4a4-d830-4e5a-a566-7c3fd4814a75	PB-2026-0001	95130003-033f-4b9a-95f2-b535ff994de1	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2017 Buick Lacrosse	15000.0	200	unpaid	2026-06-07 03:59:26.675985+00	\N
d7958a50-732e-4261-9be5-382d48f6532a	PB-2026-0002	6163c8cf-c7e0-4340-903f-bed5c42fd993	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2017 Buick Lacrosse	14000.0	200	unpaid	2026-06-08 00:33:44.314151+00	\N
eb05b092-36ab-4854-82a9-6733ed3dcd76	PB-2026-0003	0d6d7aa6-b969-482c-a7c3-38ad79d4d351	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2021 Honda Accord	21000.0	200	unpaid	2026-06-08 02:01:42.507882+00	\N
8a789aec-2503-4e27-bfd0-42ff6bab367d	PB-2026-0004	47d693a8-74d2-4b5c-a566-ca53ca4fbaad	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2017 Buick Lacrosse	14000.0	200	unpaid	2026-06-08 23:08:28.647713+00	\N
b4d3e78c-9c9e-4753-8311-dd760d0478b4	PB-2026-0005	4af8ae9b-4958-4355-b95c-f79b32e847c4	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2021 Honda Accord	21000.0	200	unpaid	2026-06-09 01:25:31.573492+00	\N
f60c9416-5d06-43e3-b2b8-be2a734235fa	PB-2026-0006	ba7fc60f-235e-4b56-937a-95b348953dda	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2017 Buick Lacrosse	14200.0	200	unpaid	2026-06-09 01:46:41.128256+00	\N
4e391514-f84f-4771-b29e-4d03e07aa2b9	PB-2026-0007	ac20b9bc-308f-4ea3-8f2d-85d575bc3597	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2021 Honda Accord	21000.0	200	unpaid	2026-06-09 22:13:56.481437+00	\N
47a1f1cb-dbf8-4de5-a82a-5e28de0e0bd9	PB-2026-0008	2baf8cc0-7536-404a-9441-98e718ac7e11	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2017 Buick Lacrosse	14000.0	200	unpaid	2026-06-10 00:07:53.096102+00	\N
d54e5aa3-2edb-4759-9385-3383f0367f29	PB-2026-0009	7072382b-9e42-46d5-9174-c03d8ffb5b12	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2017 Buick Lacrosse	14000.0	200	unpaid	2026-06-10 01:38:41.757794+00	\N
b1d7c31f-93e9-4e41-b9bf-d927d866d701	PB-2026-0010	dc42b5f7-525e-4b24-a830-dd8659fdde7b	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2021 Honda Accord	21000.0	200	unpaid	2026-06-10 17:18:30.48548+00	\N
94396d7e-9099-4277-9100-a07a73304402	PB-2026-0011	3055549a-3326-4287-a307-70acb4ecf0e9	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2021 Honda Accord	21111.0	200	unpaid	2026-06-10 17:20:39.996308+00	\N
848db2fb-13ac-4473-81c1-c4042bb828a3	PB-2026-0012	81e7313c-ed76-4112-99a9-52a951ff9494	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2021 Honda Accord	23555.0	200	unpaid	2026-06-11 21:21:29.62367+00	\N
94aec0f7-3cc8-4bbf-b5ff-29819faaac43	PB-2026-0013	88ce5202-b548-4b55-a165-4dc4febfe1a4	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2021 Honda Accord	23755.0	200	unpaid	2026-06-11 21:47:25.115731+00	\N
d018c502-17cc-4258-b5c7-021df30c1fa3	PB-2026-0014	5b3792fa-ae0b-488e-a69c-e4434b3db01a	076b239c-9426-41b6-8295-eaf832f44d70	navinbhavanimahesh55@gmail.com	Midaway Motors	2017 Buick Lacrosse	15000.0	200	unpaid	2026-06-11 22:01:53.208621+00	\N
2d4c3f0f-8f6f-4407-ae99-8d72746656eb	PB-2026-0015	d880ffeb-b6b7-4980-b3e2-ed3cd19bcb84	b1e26e84-2d55-4289-9fb8-3538bc7a65c5	navinbhavanimaheshpython@gmail.com	Tester Dealer One	2017 Buick Lacrosse	15000.0	0	unpaid	2026-06-25 14:16:01.885626+00	\N
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.offers (id, dealer_id, car_id, offer_amount, status, created_at) FROM stdin;
a5a24d7b-5a22-49e8-a20c-83ef1aa34fbc	076b239c-9426-41b6-8295-eaf832f44d70	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	15000	accepted	2026-06-05 23:12:17.744862
13e4b12d-6e92-4af1-8236-a6831492a326	076b239c-9426-41b6-8295-eaf832f44d70	ce771810-7ec0-4206-8aec-f30e24ee000f	14000	accepted	2026-06-07 21:38:27.252328
f3e12e21-2537-462a-87be-8320ef021746	076b239c-9426-41b6-8295-eaf832f44d70	b08d20b0-6b42-4a1d-8c74-28e65ccd3a0b	21000	accepted	2026-06-08 01:59:44.597242
653fbe22-cd36-42ac-a0d3-a10748012035	076b239c-9426-41b6-8295-eaf832f44d70	512cabe7-005c-4b91-b49c-1a39ceefb5f2	14000	accepted	2026-06-08 23:05:14.058156
1673066b-692b-4ac4-96fb-c525b4bfe9bb	076b239c-9426-41b6-8295-eaf832f44d70	7918e060-5fc1-4977-b0f0-d909ac7aa4a7	21000	accepted	2026-06-09 01:21:47.572467
368fafdc-1aa7-4f34-910c-046f624442c6	076b239c-9426-41b6-8295-eaf832f44d70	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	14200	accepted	2026-06-09 01:39:09.021362
cb4ff993-adf3-4e88-9e1d-3bc19d8957c8	076b239c-9426-41b6-8295-eaf832f44d70	ad1d4fbf-28a8-4a57-92d7-6a20f59fd35a	14000	rejected	2026-06-09 01:39:05.827446
00ade745-8287-4eea-9bb6-05afc22eab20	076b239c-9426-41b6-8295-eaf832f44d70	76d1762f-b57b-4d89-b0d4-35c42fbc6c1f	21000	accepted	2026-06-09 22:11:56.31266
7dad7c4c-f1e0-440e-9c65-b377c0b722ca	076b239c-9426-41b6-8295-eaf832f44d70	d04d420b-d3d7-4a52-aeec-4d93e1b4a35f	14000	accepted	2026-06-10 00:07:08.913931
a54b80d9-14d7-4fd1-8f9c-cb04d8d962a2	076b239c-9426-41b6-8295-eaf832f44d70	31eecd26-0c3d-48ae-bdc2-19f89274339c	14000	accepted	2026-06-10 01:28:06.414204
29f44b2e-224c-44dd-8d30-cefa2301ae8a	076b239c-9426-41b6-8295-eaf832f44d70	65f0b7a1-819b-4d83-a372-4e01a929c3c7	21000	accepted	2026-06-10 17:17:47.919887
3494c128-1e24-4980-b631-978dac6b72e9	076b239c-9426-41b6-8295-eaf832f44d70	9cb60658-69a9-4c9e-adec-69e86ccbf9d5	21111	accepted	2026-06-10 17:19:59.004286
6d2d3110-d4e3-4ba4-b339-d28bc84e9cdd	076b239c-9426-41b6-8295-eaf832f44d70	b77726af-0931-473e-b26d-8d9d1eaa048e	21000	accepted	2026-06-11 18:43:57.203479
1f7212d9-f96b-4b93-9930-a1285b83b402	076b239c-9426-41b6-8295-eaf832f44d70	1989c510-ce33-4732-a4d2-57925d3e495d	33000	accepted	2026-06-11 19:55:47.310794
10f73da6-42b3-4cd1-a1b9-da053182942c	076b239c-9426-41b6-8295-eaf832f44d70	e8d6e856-62bc-442a-99e0-590229cb3720	14500	accepted	2026-06-11 20:37:38.576839
31d005c5-06fc-4372-800d-2a689d5bebf0	076b239c-9426-41b6-8295-eaf832f44d70	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	23555	accepted	2026-06-11 21:12:09.693079
244266eb-5582-4ece-82d9-9a4f42eedf9c	076b239c-9426-41b6-8295-eaf832f44d70	ada5b88e-b9df-430e-b41f-3eea8de15fe8	23755	accepted	2026-06-11 21:41:56.594898
7ad43ef7-6a2d-4401-a6fe-0681534f918c	076b239c-9426-41b6-8295-eaf832f44d70	ada5b88e-b9df-430e-b41f-3eea8de15fe8	23555	rejected	2026-06-11 21:41:54.011921
51632821-2734-4579-9901-e2e2a14cc5d1	076b239c-9426-41b6-8295-eaf832f44d70	f037af4e-c70f-460b-9c16-cd2db6d8017b	15000	accepted	2026-06-11 22:00:40.255883
\.


--
-- Data for Name: pending_sellers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pending_sellers (id, name, phone, email, year, make, model, mileage, condition, prefill_token, source, status, created_at, meta_leadgen_id) FROM stdin;
1									j8pTGhCqRRCcNKLt9bPyZI_EofFKgqwTW1Bf3725o5w	meta_lead_form	pending	2026-07-05 23:46:07.035144	444444444444
\.


--
-- Data for Name: sellers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sellers (id, phone, email, created_at, password, name, reset_token, reset_token_expires) FROM stdin;
49fac9b8-04a2-4b34-9322-f99eb0d6623a	111-222-3333	gmail@gmail.com	2026-04-16 22:44:07.132	\N	\N	\N	\N
680997c1-4874-444a-95d1-529038169cf4	19292890668	navinbhavanimahesh55@gmail.com	2026-06-07 21:35:00.295531	62cdfa0c92253442e3970edd8e4de120ea503544e348a21a44a40e21318bc99d	Bhavani Mahesh	\N	\N
c1ccb925-5eb9-4a60-a138-ff55850e45dc	2603638885	teovidalibre@gmail.com	2026-06-24 22:21:55.455449	16d6763c6802a37c902840c77593f47b36d258846ad964bad14836a0e1b54409	Teodoro Escobar	\N	\N
22fd2a6e-bcb8-4eff-916a-5d82fcd0feff	19292890668	navin@privabuy.com	2026-06-28 13:13:01.318468	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
b4ff9497-2863-49c3-9e64-5cc4724a07fe	19292890668	kishanap1500@gmail.com	2026-06-29 13:12:33.178565	62cdfa0c92253442e3970edd8e4de120ea503544e348a21a44a40e21318bc99d	Navin Bhavani Mahesh	\N	\N
020ce5f0-cd7d-4255-a76d-9a4974d56823	19292890668	navinbhavanimahesh@gmail.com	2026-06-30 14:12:37.221102	62cdfa0c92253442e3970edd8e4de120ea503544e348a21a44a40e21318bc99d	Navin Bhavani Mahesh	\N	\N
78d6e99f-d2b0-4a56-bc81-921e73e3aff3	3173246329	tamikowoods39@yahoo.com	2026-07-04 14:16:56.087188	49e949366823894405a0d04a086b144335eb0b086a2238d6fcd1cc2f07562800	Tamiko woods	63kcZr5QLF4nwLbbqjIfaQOcUlpn7C2aOrK1nFu3LB8	2026-07-04 17:10:38.659333
e1f7cce8-4ff3-4dcb-b4c5-761a4c9f116d	19292890668	testeremail@1015	2026-07-07 00:23:28.01445	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
25da8bbb-9166-4c05-a28b-dccadaa41ee4	19292890668	testeremail3@1015	2026-07-07 01:01:30.163346	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
afccc862-d075-4b58-a6c9-317be4480364	3332223344	timindavis@gmail.com	2026-04-17 17:48:22.852682	\N	\N	\N	\N
a0665247-e343-440a-9b77-21c276457173	19292890668	testeremail5@1015	2026-07-07 01:02:28.439664	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
469b1af6-13b4-4406-8333-631180db948d	19292890668	testeremail8@1015	2026-07-07 01:12:29.636785	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
59940133-62c6-4ad2-b0ab-f6eb8b2d8f4d	19292890668	testeremail10@1015	2026-07-07 01:53:24.562662	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
08b0f785-c312-4141-84b2-6a0657fbd0a3	19292890668	testeremail12@1015	2026-07-07 02:27:58.95271	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
bea976e5-2f4b-4547-919c-e608647dfbe6	19292890668	testeremail20@1015	2026-07-07 19:07:34.282895	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
ba74401f-92d4-4d81-8ce3-abf16da98203	3332223344	timindavis@gmail.com	2026-04-26 17:44:02.184519	\N	\N	\N	\N
001b0b8c-95b4-4985-aaaf-5730b8fc0dd3	4196055859	donnalynn99@duck.com	2026-06-24 20:17:48.308923	c6d114d3cc26d52d88a9d8e5985a5269d79c1c644d0f1178c1e33176fa84814b	Donna Pierce	\N	\N
385b3172-a038-472d-9890-7ba6fcf62fb4	19292890668	kishanp8@gmail.com	2026-06-27 17:48:34.882179	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
8ff1f9f8-ec21-45fe-8c05-63c31ad90a3d	19292890668	kishanap1600@gmail.com	2026-06-28 18:21:39.569767	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
cf380f90-f0d4-4c27-9a94-8304b7bac58c	19292890668	milesicecold@gmail.com	2026-06-29 13:18:30.56462	62cdfa0c92253442e3970edd8e4de120ea503544e348a21a44a40e21318bc99d	Navin Bhavani Mahesh	\N	\N
80993f9e-272f-4e37-ada4-eeecbf823424	7606916362	balambor008@gmail.com	2026-07-03 01:09:53.338506	a5af65401c254ac32c7516d8d77ad6fbe57847a1dcfaab8b38aa196c8210ad7c	Ba lam	\N	\N
90c3b299-b73c-4182-8784-5d085d0f1e6b	19292890668	oshaque@1234	2026-07-06 23:36:17.007595	1f15a1fbdf250ace854be870c00a6b64984a97f9f448628916e55cbbb900fe9d	Navin Bhavani Mahesh	\N	\N
5a59e45f-c966-40e0-b1b9-778ebcbf00a1	19292890668	testeremail2@1015	2026-07-07 00:29:46.783844	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
cdb4ccd8-a826-467a-929d-02b05c28d788	19292890668	testeremail4@1015	2026-07-07 01:02:07.229438	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
e8fe0441-abc3-4342-a536-76258a2fcc6c	19292890668	testeremaill7@1015	2026-07-07 01:09:43.427879	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
dd3a3972-b970-4121-a691-b6e21753a9ab	19292890668	testeremaill9@1015	2026-07-07 01:14:06.52187	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
b13ad60d-3976-48ba-9e8d-9956ac90e709	19292890668	testeremail11@1015	2026-07-07 02:13:01.952675	9bd0d4a8ddd4157c7bd3f10d374fe04c9a4e555c34f8a7455b51a0422aff4cb1	Navin Bhavani Mahesh	\N	\N
66f0d0f9-6865-4720-8a3b-ca3a0342c80b	19292890668	testeremail13@1015	2026-07-07 02:28:31.717026	105658c4ff5a7dbb8aa6c473ccaa9db3615efd77b5af4d2f4679f2951782ba69	Navin Bhavani Mahesh	\N	\N
333385ac-1ef2-4681-bb13-3e66783a2e00	19292890668	navin.bm25@gmail.com	2026-05-01 06:04:07.879156	62cdfa0c92253442e3970edd8e4de120ea503544e348a21a44a40e21318bc99d	Navin Bhavani Mahesh	\N	\N
8b66bb6c-3e18-43d1-8069-886a4d79e3b7	19292890668	gearloom.ai@gmail.com	2026-05-06 03:26:26.933688	62cdfa0c92253442e3970edd8e4de120ea503544e348a21a44a40e21318bc99d	Navin	\N	\N
3ee90ae9-639f-4929-a869-c7662e8e8952	19292890668	navinbhavani.m@gmail.com	2026-05-06 03:40:37.868865	62cdfa0c92253442e3970edd8e4de120ea503544e348a21a44a40e21318bc99d	Navin	\N	\N
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transactions (transaction_id, offer_id, car_id, dealer_id, seller_id, amount, status, dealer_payment_deadline, dealer_fee_paid, dealer_paid_at, bill_of_sale_dealer_acked, bill_of_sale_seller_acked, dealer_acked_at, seller_acked_at, pickup_slot_1, pickup_slot_2, pickup_slot_3, slots_proposed_at, confirmed_pickup_slot, slot_confirmed_at, pickup_confirmed, pickup_confirmed_at, vehicle_as_described, discrepancy_note, seller_payment_confirmed, seller_payment_confirmed_at, seller_fee_paid, seller_paid_at, completed_at, forfeited_at, created_at, inspection_deadline, inspection_reject_reason, inspection_accepted_at, inspection_rejected_at, dispute_evidence_urls, dispute_category, dispute_submitted_at, refund_status, refund_issued_at, has_accident, pre_dispute_status, resume_status, resolved_at, title_confirmed_at, title_photo_url, title_confirmed_by) FROM stdin;
d880ffeb-b6b7-4980-b3e2-ed3cd19bcb84	d07a21a6-a2af-40e1-9818-63a955d4df4c	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	b1e26e84-2d55-4289-9fb8-3538bc7a65c5	49fac9b8-04a2-4b34-9322-f99eb0d6623a	15000.00	awaiting_bill_of_sale	\N	f	\N	t	f	2026-07-02 10:28:56.448979	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	f	\N	\N	\N	2026-06-25 14:15:41.970956	\N	\N	\N	\N	\N	\N	\N	none	\N	f	\N	\N	\N	\N	\N	\N
2baf8cc0-7536-404a-9441-98e718ac7e11	7dad7c4c-f1e0-440e-9c65-b377c0b722ca	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	14000.00	completed	2026-06-11 00:07:14.128021	f	\N	t	t	2026-06-10 00:09:07.16201	2026-06-10 00:09:24.099113	2026-06-24T20:10	2026-06-18T20:10	2026-07-09T20:10	2026-06-10 00:10:40.273266	2026-06-24T20:10	2026-06-10 00:12:55.590419	t	2026-06-10 00:13:08.300443	t	\N	t	2026-06-10 00:13:25.377263	f	\N	2026-06-10 00:13:25.377266	\N	2026-06-10 00:07:14.129071	2026-06-11 00:13:08.300432	\N	2026-06-10 00:13:18.386301	\N	\N	\N	\N	none	\N	f	\N	\N	\N	\N	\N	\N
7072382b-9e42-46d5-9174-c03d8ffb5b12	a54b80d9-14d7-4fd1-8f9c-cb04d8d962a2	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	14000.00	completed	2026-06-11 01:28:14.971772	f	\N	t	t	2026-06-10 03:39:21.148761	2026-06-10 03:38:27.033124	2026-06-25T01:21	2026-06-23T01:21	2026-06-20T01:21	2026-06-10 05:21:49.145765	2026-06-25T01:21	2026-06-10 05:22:19.384275	t	2026-06-10 05:24:59.838791	t	\N	t	2026-06-10 05:25:44.66991	f	\N	2026-06-10 05:25:44.669914	\N	2026-06-10 01:28:14.973968	2026-06-11 05:24:59.838781	Title Issue: transmission shudders ect...	2026-06-10 05:25:19.47638	2026-06-10 05:23:37.387882	{https://res.cloudinary.com/dptom0qr7/image/upload/v1781068970/jxscymndfduc6qkdsev2.svg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781068972/puy7hzfc4niwfp03zeyz.svg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781068978/pqw4dkzjryvs2imxxs1y.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781068979/uieq8t0rj7a9s8vm7ltj.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781068982/ra6buuhmureq6czoxfuy.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781068984/vom9jcohqowwb6s6msts.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781068987/tr8hrjdcuhax7ghsunxw.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781068990/mptwgzpcmejstiqx8kef.jpg}	Title issue not disclosed	2026-06-10 05:23:37.387886	none	\N	f	pickup_scheduled	pickup_scheduled	2026-06-10 05:24:38.031202	\N	\N	\N
47d693a8-74d2-4b5c-a566-ca53ca4fbaad	653fbe22-cd36-42ac-a0d3-a10748012035	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	14000.00	completed	2026-06-09 23:05:22.642886	f	\N	t	t	2026-06-08 23:58:53.812464	2026-06-08 23:59:02.458717	2026-06-20T23:59	2026-06-24T19:03	2026-06-18T19:03	2026-06-08 23:59:23.432584	2026-06-20T23:59	2026-06-08 23:59:28.882836	t	2026-06-08 23:59:38.687603	f	\N	t	2026-06-09 01:18:17.029984	f	\N	2026-06-09 01:18:17.029991	\N	2026-06-08 23:05:22.642897	\N	Test dispute	\N	2026-06-09 00:54:10.683325	\N	Vehicle condition materially different from photos	2026-06-09 00:54:10.683325	denied	\N	f	\N	\N	\N	\N	\N	\N
3055549a-3326-4287-a307-70acb4ecf0e9	3494c128-1e24-4980-b631-978dac6b72e9	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	21111.00	awaiting_bill_of_sale	2026-06-11 17:20:08.75829	f	\N	t	f	2026-06-10 17:43:50.955677	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	f	\N	\N	\N	2026-06-10 17:20:08.760383	\N	\N	\N	\N	\N	\N	\N	none	\N	f	\N	\N	\N	\N	\N	\N
c3397181-50ba-4bdf-8193-324de1d5de8a	1f7212d9-f96b-4b93-9930-a1285b83b402	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	33000.00	awaiting_dealer_payment	2026-06-12 19:55:53.237143	f	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	f	\N	\N	\N	2026-06-11 19:55:53.239126	\N	\N	\N	\N	\N	\N	\N	none	\N	f	\N	\N	\N	\N	\N	\N
81e7313c-ed76-4112-99a9-52a951ff9494	31d005c5-06fc-4372-800d-2a689d5bebf0	b9c96e0a-09d1-49bc-acef-1eb0fcc596e1	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	23555.00	completed	2026-06-12 21:12:18.821868	f	\N	t	t	2026-06-11 21:28:56.181198	2026-06-11 21:28:49.032434	2026-06-17T17:29	2026-06-26T17:29	2026-06-08T17:29	2026-06-11 21:29:09.93052	2026-06-17T17:29	2026-06-11 21:32:55.115336	t	2026-06-11 21:33:01.028186	t	\N	t	2026-06-11 21:33:20.894316	f	\N	2026-06-11 21:33:20.894324	\N	2026-06-11 21:12:18.824192	2026-06-12 21:33:01.028164	\N	2026-06-11 21:33:15.949651	\N	\N	\N	\N	none	\N	f	\N	\N	\N	\N	\N	\N
5b3792fa-ae0b-488e-a69c-e4434b3db01a	51632821-2734-4579-9901-e2e2a14cc5d1	f037af4e-c70f-460b-9c16-cd2db6d8017b	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	15000.00	completed	2026-06-12 22:00:45.086187	f	\N	t	t	2026-06-13 09:31:33.898266	2026-06-13 09:30:57.157287	2026-06-12T05:31	2026-06-23T05:31	2026-06-26T05:31	2026-06-13 09:31:48.337409	2026-06-12T05:31	2026-06-13 09:34:27.775347	t	2026-06-13 09:34:33.227889	t	\N	t	2026-06-13 09:34:40.281625	f	\N	2026-06-13 09:34:40.281627	\N	2026-06-11 22:00:45.088457	2026-06-14 09:34:33.22788	\N	2026-06-13 09:34:36.091239	\N	\N	\N	\N	none	\N	f	\N	\N	\N	\N	\N	\N
ba7fc60f-235e-4b56-937a-95b348953dda	368fafdc-1aa7-4f34-910c-046f624442c6	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	14200.00	awaiting_bill_of_sale	2026-06-10 01:39:18.736458	f	\N	t	t	2026-06-09 01:46:54.639335	2026-06-09 01:46:57.26324	2026-06-20T21:49	2026-06-12T21:49	2026-06-25T21:49	2026-06-09 01:49:48.011319	2026-06-20T21:49	2026-06-09 01:49:54.102476	f	\N	\N	\N	f	\N	f	\N	\N	\N	2026-06-09 01:39:18.738848	\N	Mileage Inconsistency	\N	2026-06-09 02:01:02.932811	{https://res.cloudinary.com/dptom0qr7/image/upload/v1780969942/jrurjoyrtpzjjic0ycb5.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1780969943/wt3z4fbxi0ufhijpdbls.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1780969947/mqbpfa629rv8dgumqoa7.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1780969949/lqpylldtu2wwhtufyv45.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1780969954/f1nkeabqqzl0fbp9qk6q.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1780969959/le0tpbtqonx2rpvcqgno.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1780969960/vtbezuifunzwdhjz0zpv.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1780969963/n3odhs1micqluvzc1kge.svg}	Mileage inconsistency	2026-06-09 02:01:02.932817	denied	\N	f	\N	\N	\N	\N	\N	\N
dc42b5f7-525e-4b24-a830-dd8659fdde7b	29f44b2e-224c-44dd-8d30-cefa2301ae8a	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	21000.00	inspection_period	2026-06-11 17:17:54.574852	f	\N	t	t	2026-06-10 17:59:49.893363	2026-06-10 17:43:54.440662	2026-06-16T20:25	2026-07-07T20:25	2026-06-16T20:25	2026-06-11 00:25:08.824008	2026-06-16T20:25	2026-06-11 00:25:19.468746	t	2026-06-11 00:25:35.836624	t	\N	f	\N	f	\N	\N	\N	2026-06-10 17:17:54.578804	2026-06-12 00:25:35.836614	\N	\N	\N	\N	\N	\N	none	\N	f	\N	\N	\N	\N	\N	\N
9b82a1dc-5b45-46d8-94ab-761ee7a408a2	6d2d3110-d4e3-4ba4-b339-d28bc84e9cdd	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	21000.00	awaiting_dealer_payment	2026-06-12 18:44:27.569923	f	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	f	\N	\N	\N	2026-06-11 18:44:27.571919	\N	\N	\N	\N	\N	\N	\N	none	\N	f	\N	\N	\N	\N	\N	\N
361b9259-a291-4734-8b88-3bd10cf71dfd	10f73da6-42b3-4cd1-a1b9-da053182942c	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	14500.00	awaiting_dealer_payment	2026-06-12 20:37:47.609572	f	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	f	\N	\N	\N	2026-06-11 20:37:47.61174	\N	\N	\N	\N	\N	\N	\N	none	\N	f	\N	\N	\N	\N	\N	\N
4af8ae9b-4958-4355-b95c-f79b32e847c4	1673066b-692b-4ac4-96fb-c525b4bfe9bb	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	21000.00	dispute_resolved_denied	2026-06-10 01:21:55.060434	f	\N	t	t	2026-06-09 01:26:08.025697	2026-06-09 01:26:01.653838	2026-06-19T21:26	2026-06-20T21:26	2026-06-17T21:26	2026-06-09 01:26:21.166578	2026-06-19T21:26	2026-06-09 01:29:37.071026	t	2026-06-09 01:29:59.789418	f	tires are not as described	f	\N	f	\N	\N	\N	2026-06-09 01:21:55.062524	\N	\N	\N	\N	\N	\N	\N	refunded	2026-06-09 01:37:10.484785	f	inspection_period	inspection_period	2026-06-09 06:46:37.360151	\N	\N	\N
88ce5202-b548-4b55-a165-4dc4febfe1a4	244266eb-5582-4ece-82d9-9a4f42eedf9c	ada5b88e-b9df-430e-b41f-3eea8de15fe8	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	23755.00	dispute_resolved_refund	2026-06-12 21:42:02.572963	f	\N	t	t	2026-06-11 21:47:37.277957	2026-06-11 21:47:32.065888	2026-06-19T17:47	2026-06-16T17:47	2026-07-02T17:47	2026-06-11 21:47:51.438732	2026-06-19T17:47	2026-06-11 21:48:12.73591	f	\N	\N	\N	f	\N	f	\N	\N	\N	2026-06-11 21:42:02.575404	\N	Accident Damage	\N	2026-06-11 21:50:51.345715	{https://res.cloudinary.com/dptom0qr7/image/upload/v1781214504/iu6ac9gfafbgnrwyfbu1.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781214505/wqpcfgkri3e2pqw8hnao.svg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781214501/yrzczff5ktzg5whgh3yl.svg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781214507/t9xpeir4lha2c8x4znbt.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781214636/za2vi7fzqlgj66bnexa7.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781214638/zonmetb2jmcs83a8ciuf.svg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781214642/wvbo8gm2agrktzotplou.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781214643/xutwhkyo7yhmjindsoms.jpg}	Accident damage not disclosed	2026-06-11 21:50:51.345721	none	\N	f	pickup_scheduled	\N	2026-06-11 21:52:33.458818	\N	\N	\N
ac20b9bc-308f-4ea3-8f2d-85d575bc3597	00ade745-8287-4eea-9bb6-05afc22eab20	ceee9ed3-47d9-4b56-91c3-bcfcb6cc6819	076b239c-9426-41b6-8295-eaf832f44d70	680997c1-4874-444a-95d1-529038169cf4	21000.00	completed	2026-06-10 22:12:02.667076	f	\N	t	t	2026-06-09 22:14:08.840955	2026-06-09 22:14:11.392506	2026-06-18T18:14	2026-06-20T18:14	2026-06-18T18:14	2026-06-09 22:14:24.922776	2026-06-18T18:14	2026-06-09 22:14:29.099636	t	2026-06-09 22:16:00.130201	t	\N	t	2026-06-10 00:00:48.066867	f	\N	2026-06-10 00:00:48.066869	\N	2026-06-09 22:12:02.667898	2026-06-10 22:16:00.130191	Engine / Transmission: Transmsission shudders	2026-06-09 22:16:13.368089	2026-06-09 22:15:11.959163	{https://res.cloudinary.com/dptom0qr7/image/upload/v1781043278/idnpjaxdloz74hfcfjuk.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781043279/pxh2i2aoywvmhgyfw3oa.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781043281/i8mla9opdtan5jt9a6hq.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781043283/t4aqysotwpoocwyucpu4.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781043286/yzhl8foaxinnkxuaiwjb.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781043290/wpfb8kt0rhsqu8xlknov.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781043293/vut9ccx2qomxq4gecldy.jpg,https://res.cloudinary.com/dptom0qr7/image/upload/v1781043297/lo3a2xtrqx72eve9gzb1.jpg}	Undisclosed mechanical issue	2026-06-09 22:15:11.959168	none	\N	f	pickup_scheduled	pickup_scheduled	2026-06-09 22:15:46.7638	\N	\N	\N
\.


--
-- Name: pending_sellers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pending_sellers_id_seq', 1, true);


--
-- Name: app_settings app_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_settings
    ADD CONSTRAINT app_settings_pkey PRIMARY KEY (key);


--
-- Name: cars cars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_pkey PRIMARY KEY (car_id);


--
-- Name: dealer_car_connections dealer_car_connections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dealer_car_connections
    ADD CONSTRAINT dealer_car_connections_pkey PRIMARY KEY (id);


--
-- Name: dealer_notifications dealer_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dealer_notifications
    ADD CONSTRAINT dealer_notifications_pkey PRIMARY KEY (id);


--
-- Name: dealers dealers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dealers
    ADD CONSTRAINT dealers_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_invoice_number_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_invoice_number_key UNIQUE (invoice_number);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (invoice_id);


--
-- Name: offers offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (id);


--
-- Name: pending_sellers pending_sellers_meta_leadgen_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_sellers
    ADD CONSTRAINT pending_sellers_meta_leadgen_id_key UNIQUE (meta_leadgen_id);


--
-- Name: pending_sellers pending_sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_sellers
    ADD CONSTRAINT pending_sellers_pkey PRIMARY KEY (id);


--
-- Name: pending_sellers pending_sellers_prefill_token_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pending_sellers
    ADD CONSTRAINT pending_sellers_prefill_token_key UNIQUE (prefill_token);


--
-- Name: sellers sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: idx_cars_seller; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cars_seller ON public.cars USING btree (seller_id);


--
-- Name: idx_cars_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cars_status ON public.cars USING btree (status);


--
-- Name: idx_offers_car; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offers_car ON public.offers USING btree (car_id);


--
-- Name: idx_offers_dealer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_offers_dealer ON public.offers USING btree (dealer_id);


--
-- Name: idx_transactions_car; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_transactions_car ON public.transactions USING btree (car_id);


--
-- Name: idx_transactions_dealer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_transactions_dealer ON public.transactions USING btree (dealer_id);


--
-- Name: idx_transactions_seller; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_transactions_seller ON public.transactions USING btree (seller_id);


--
-- Name: idx_transactions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_transactions_status ON public.transactions USING btree (status);


--
-- Name: cars cars_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cars
    ADD CONSTRAINT cars_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.sellers(id);


--
-- Name: dealer_car_connections dealer_car_connections_car_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dealer_car_connections
    ADD CONSTRAINT dealer_car_connections_car_id_fkey FOREIGN KEY (car_id) REFERENCES public.cars(car_id);


--
-- Name: dealer_car_connections dealer_car_connections_dealer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dealer_car_connections
    ADD CONSTRAINT dealer_car_connections_dealer_id_fkey FOREIGN KEY (dealer_id) REFERENCES public.dealers(id);


--
-- Name: dealer_notifications dealer_notifications_car_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dealer_notifications
    ADD CONSTRAINT dealer_notifications_car_id_fkey FOREIGN KEY (car_id) REFERENCES public.cars(car_id);


--
-- Name: dealer_notifications dealer_notifications_dealer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dealer_notifications
    ADD CONSTRAINT dealer_notifications_dealer_id_fkey FOREIGN KEY (dealer_id) REFERENCES public.dealers(id);


--
-- Name: offers offers_car_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_car_id_fkey FOREIGN KEY (car_id) REFERENCES public.cars(car_id);


--
-- Name: offers offers_dealer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offers
    ADD CONSTRAINT offers_dealer_id_fkey FOREIGN KEY (dealer_id) REFERENCES public.dealers(id);


--
-- PostgreSQL database dump complete
--

\unrestrict Y0r27s22xWZioV5kYHFmLIGguFbily7Ywld0GOhzx9Cy2CIbKgJnnK6RFaXydDb

