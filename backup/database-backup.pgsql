--
-- PostgreSQL database dump
--

-- Dumped from database version 12.13
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: bill_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.bill_status_enum AS ENUM (
    'unauthorized',
    'paid',
    'failed',
    'cancelled'
);


ALTER TYPE public.bill_status_enum OWNER TO postgres;

--
-- Name: bill_vendor_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.bill_vendor_enum AS ENUM (
    'vnpay',
    'locamos'
);


ALTER TYPE public.bill_vendor_enum OWNER TO postgres;

--
-- Name: location_nft_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.location_nft_status_enum AS ENUM (
    'pending',
    'rejected',
    'approved',
    'minted'
);


ALTER TYPE public.location_nft_status_enum OWNER TO postgres;

--
-- Name: location_purchase_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.location_purchase_status_enum AS ENUM (
    'unauthorized',
    'failed'
);


ALTER TYPE public.location_purchase_status_enum OWNER TO postgres;

--
-- Name: location_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.location_status_enum AS ENUM (
    'pending',
    'rejected',
    'approved'
);


ALTER TYPE public.location_status_enum OWNER TO postgres;

--
-- Name: location_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.location_type_enum AS ENUM (
    'admin',
    'customer'
);


ALTER TYPE public.location_type_enum OWNER TO postgres;

--
-- Name: order_payment_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_payment_status_enum AS ENUM (
    'unauthorized',
    'paid',
    'failed',
    'cancelled'
);


ALTER TYPE public.order_payment_status_enum OWNER TO postgres;

--
-- Name: order_payment_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_payment_type_enum AS ENUM (
    'cash',
    'point',
    'package'
);


ALTER TYPE public.order_payment_type_enum OWNER TO postgres;

--
-- Name: payment_log_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_log_type_enum AS ENUM (
    'request',
    'webhook'
);


ALTER TYPE public.payment_log_type_enum OWNER TO postgres;

--
-- Name: user_package_purchase_status_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_package_purchase_status_enum AS ENUM (
    'unauthorized',
    'failed',
    'paid'
);


ALTER TYPE public.user_package_purchase_status_enum OWNER TO postgres;

--
-- Name: user_status_kyc_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_status_kyc_enum AS ENUM (
    'PENDING',
    'FAIL',
    'SUCCESS'
);


ALTER TYPE public.user_status_kyc_enum OWNER TO postgres;

--
-- Name: user_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_type_enum AS ENUM (
    'admin',
    'customer'
);


ALTER TYPE public.user_type_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: bank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank (
    id integer NOT NULL,
    name character varying NOT NULL,
    short_name character varying NOT NULL,
    logo character varying NOT NULL
);


ALTER TABLE public.bank OWNER TO postgres;

--
-- Name: bank_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bank_id_seq OWNER TO postgres;

--
-- Name: bank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bank_id_seq OWNED BY public.bank.id;


--
-- Name: bill; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bill (
    id integer NOT NULL,
    ref_id character varying NOT NULL,
    order_id integer NOT NULL,
    status public.bill_status_enum DEFAULT 'unauthorized'::public.bill_status_enum NOT NULL,
    vendor public.bill_vendor_enum DEFAULT 'vnpay'::public.bill_vendor_enum NOT NULL,
    invoice_number character varying,
    version integer DEFAULT 1 NOT NULL,
    created_by_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.bill OWNER TO postgres;

--
-- Name: bill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bill_id_seq OWNER TO postgres;

--
-- Name: bill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bill_id_seq OWNED BY public.bill.id;


--
-- Name: city; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.city (
    id integer NOT NULL,
    name character varying
);


ALTER TABLE public.city OWNER TO postgres;

--
-- Name: city_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.city_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.city_id_seq OWNER TO postgres;

--
-- Name: city_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.city_id_seq OWNED BY public.city.id;


--
-- Name: commission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commission (
    id integer NOT NULL,
    direct_commission integer NOT NULL,
    weekly_commission integer NOT NULL,
    monthly_commission integer NOT NULL,
    group_commission integer NOT NULL
);


ALTER TABLE public.commission OWNER TO postgres;

--
-- Name: commission_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commission_history (
    id integer NOT NULL,
    type character varying NOT NULL,
    transaction character varying DEFAULT 'Th???c hi???n thanh to??n'::character varying NOT NULL,
    transaction_owner_id integer,
    transaction_amount double precision,
    percentage double precision,
    commission double precision,
    order_id integer,
    commission_receiver_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.commission_history OWNER TO postgres;

--
-- Name: commission_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.commission_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commission_history_id_seq OWNER TO postgres;

--
-- Name: commission_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.commission_history_id_seq OWNED BY public.commission_history.id;


--
-- Name: commission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.commission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commission_id_seq OWNER TO postgres;

--
-- Name: commission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.commission_id_seq OWNED BY public.commission.id;


--
-- Name: contract; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract (
    id integer NOT NULL,
    buyer_id integer NOT NULL,
    owner_id integer NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone character varying NOT NULL,
    identification_number character varying,
    identification_created_from character varying,
    identification_created_at character varying,
    address character varying NOT NULL
);


ALTER TABLE public.contract OWNER TO postgres;

--
-- Name: contract_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contract_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contract_id_seq OWNER TO postgres;

--
-- Name: contract_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contract_id_seq OWNED BY public.contract.id;


--
-- Name: contract_location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contract_location (
    id integer NOT NULL,
    link_soft character varying,
    link_pdf character varying,
    link_certification character varying,
    contract_id integer NOT NULL,
    user_id integer NOT NULL,
    location_id integer NOT NULL,
    link_signature character varying
);


ALTER TABLE public.contract_location OWNER TO postgres;

--
-- Name: contract_location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contract_location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contract_location_id_seq OWNER TO postgres;

--
-- Name: contract_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contract_location_id_seq OWNED BY public.contract_location.id;


--
-- Name: district; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.district (
    id integer NOT NULL,
    name character varying,
    city integer
);


ALTER TABLE public.district OWNER TO postgres;

--
-- Name: district_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.district_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.district_id_seq OWNER TO postgres;

--
-- Name: district_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.district_id_seq OWNED BY public.district.id;


--
-- Name: info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.info (
    id integer NOT NULL,
    address character varying,
    aff_link character varying,
    agency integer DEFAULT 0 NOT NULL,
    birthday character varying,
    code character varying,
    email character varying,
    is_email_verified boolean DEFAULT false NOT NULL,
    is_phone_verified boolean DEFAULT false NOT NULL,
    phone character varying,
    name character varying,
    kyc_state integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.info OWNER TO postgres;

--
-- Name: info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.info_id_seq OWNER TO postgres;

--
-- Name: info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.info_id_seq OWNED BY public.info.id;


--
-- Name: job_register; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.job_register (
    name character varying NOT NULL,
    is_process boolean NOT NULL
);


ALTER TABLE public.job_register OWNER TO postgres;

--
-- Name: level; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.level (
    id integer NOT NULL,
    level_name character varying DEFAULT ''::character varying NOT NULL,
    min_income integer DEFAULT 0 NOT NULL,
    min_branch integer DEFAULT 3 NOT NULL,
    min_top3_income integer DEFAULT 0 NOT NULL,
    shared_commission integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.level OWNER TO postgres;

--
-- Name: level_company; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.level_company (
    id integer NOT NULL,
    level_name character varying DEFAULT ''::character varying NOT NULL,
    commission integer DEFAULT 0 NOT NULL,
    f1_qualified integer DEFAULT 0 NOT NULL,
    min_kpi integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.level_company OWNER TO postgres;

--
-- Name: level_company_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.level_company_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.level_company_id_seq OWNER TO postgres;

--
-- Name: level_company_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.level_company_id_seq OWNED BY public.level_company.id;


--
-- Name: level_company_pending; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.level_company_pending (
    id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    level_pending integer NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL
);


ALTER TABLE public.level_company_pending OWNER TO postgres;

--
-- Name: level_company_pending_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.level_company_pending_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.level_company_pending_id_seq OWNER TO postgres;

--
-- Name: level_company_pending_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.level_company_pending_id_seq OWNED BY public.level_company_pending.id;


--
-- Name: level_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.level_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.level_id_seq OWNER TO postgres;

--
-- Name: level_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.level_id_seq OWNED BY public.level.id;


--
-- Name: location; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location (
    id integer NOT NULL,
    name character varying NOT NULL,
    handle character varying NOT NULL,
    map_captured character varying,
    long double precision NOT NULL,
    lat double precision NOT NULL,
    safe_zone_top double precision NOT NULL,
    safe_zone_bot double precision NOT NULL,
    safe_zone_left double precision NOT NULL,
    safe_zone_right double precision NOT NULL,
    type public.location_type_enum NOT NULL,
    status public.location_status_enum NOT NULL,
    purchase_status public.location_purchase_status_enum,
    nft_status public.location_nft_status_enum DEFAULT 'pending'::public.location_nft_status_enum NOT NULL,
    is_blacklist boolean DEFAULT false NOT NULL,
    block_radius integer NOT NULL,
    country character varying DEFAULT 'VN'::character varying NOT NULL,
    province character varying,
    district character varying,
    commune character varying,
    street character varying,
    token_id integer,
    user_full_name character varying,
    approved_by_id integer,
    approved_at timestamp without time zone DEFAULT now(),
    paid_at timestamp without time zone,
    version integer DEFAULT 1 NOT NULL,
    contrac_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    bsc_scan_link character varying,
    user_id integer,
    user_name_owner character varying,
    created_by_id integer
);


ALTER TABLE public.location OWNER TO postgres;

--
-- Name: location_handle; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.location_handle (
    name character varying NOT NULL,
    total integer NOT NULL
);


ALTER TABLE public.location_handle OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.location_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.location_id_seq OWNER TO postgres;

--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.location_id_seq OWNED BY public.location.id;


--
-- Name: lock_zone; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lock_zone (
    id integer NOT NULL,
    "timeStart" timestamp without time zone NOT NULL,
    name character varying DEFAULT 'please update name'::character varying NOT NULL,
    "timeEnd" timestamp without time zone NOT NULL,
    type character varying NOT NULL,
    district_id integer,
    province_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.lock_zone OWNER TO postgres;

--
-- Name: lock_zone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lock_zone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lock_zone_id_seq OWNER TO postgres;

--
-- Name: lock_zone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lock_zone_id_seq OWNED BY public.lock_zone.id;


--
-- Name: log_loca_bonus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_loca_bonus (
    id integer NOT NULL,
    loca_bonus double precision NOT NULL,
    user_id integer NOT NULL,
    sender_id integer,
    loca_bonus_remaining double precision NOT NULL,
    order_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.log_loca_bonus OWNER TO postgres;

--
-- Name: log_loca_bonus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_loca_bonus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_loca_bonus_id_seq OWNER TO postgres;

--
-- Name: log_loca_bonus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_loca_bonus_id_seq OWNED BY public.log_loca_bonus.id;


--
-- Name: log_update_wallet3rd; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_update_wallet3rd (
    id integer NOT NULL,
    user_id integer NOT NULL,
    loca integer,
    usd integer,
    note character varying,
    client_id character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.log_update_wallet3rd OWNER TO postgres;

--
-- Name: log_update_wallet3rd_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_update_wallet3rd_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_update_wallet3rd_id_seq OWNER TO postgres;

--
-- Name: log_update_wallet3rd_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_update_wallet3rd_id_seq OWNED BY public.log_update_wallet3rd.id;


--
-- Name: manage_price_by_date; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manage_price_by_date (
    id integer NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    active boolean DEFAULT false NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    created_by integer NOT NULL,
    updated_by integer NOT NULL
);


ALTER TABLE public.manage_price_by_date OWNER TO postgres;

--
-- Name: manage_price_by_date_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manage_price_by_date_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.manage_price_by_date_id_seq OWNER TO postgres;

--
-- Name: manage_price_by_date_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manage_price_by_date_id_seq OWNED BY public.manage_price_by_date.id;


--
-- Name: manage_price_by_routine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manage_price_by_routine (
    id integer NOT NULL,
    type character varying,
    days_of_week integer[],
    weeks_of_month integer[],
    months integer[],
    repeat boolean DEFAULT false NOT NULL,
    active boolean DEFAULT false NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    created_by integer NOT NULL,
    updated_by integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.manage_price_by_routine OWNER TO postgres;

--
-- Name: manage_price_by_routine_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manage_price_by_routine_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.manage_price_by_routine_id_seq OWNER TO postgres;

--
-- Name: manage_price_by_routine_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manage_price_by_routine_id_seq OWNED BY public.manage_price_by_routine.id;


--
-- Name: manage_price_package; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manage_price_package (
    id integer NOT NULL,
    type character varying DEFAULT ''::character varying NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    price_id integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.manage_price_package OWNER TO postgres;

--
-- Name: manage_price_package_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manage_price_package_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.manage_price_package_id_seq OWNER TO postgres;

--
-- Name: manage_price_package_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manage_price_package_id_seq OWNED BY public.manage_price_package.id;


--
-- Name: notify; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notify (
    id integer NOT NULL,
    title character varying NOT NULL,
    "timeStart" timestamp without time zone NOT NULL,
    type character varying NOT NULL,
    conten text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.notify OWNER TO postgres;

--
-- Name: notify_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notify_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notify_id_seq OWNER TO postgres;

--
-- Name: notify_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notify_id_seq OWNED BY public.notify.id;


--
-- Name: order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."order" (
    id integer NOT NULL,
    payment_type public.order_payment_type_enum DEFAULT 'cash'::public.order_payment_type_enum NOT NULL,
    payment_status public.order_payment_status_enum DEFAULT 'unauthorized'::public.order_payment_status_enum NOT NULL,
    price double precision NOT NULL,
    note character varying NOT NULL,
    location_id integer,
    user_package_id integer,
    version integer DEFAULT 1 NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    created_by_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."order" OWNER TO postgres;

--
-- Name: order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.order_id_seq OWNER TO postgres;

--
-- Name: order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_id_seq OWNED BY public."order".id;


--
-- Name: package; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.package (
    id integer NOT NULL,
    ref_id character varying NOT NULL,
    name character varying NOT NULL,
    quantity integer NOT NULL,
    promotion double precision,
    discount double precision,
    version integer DEFAULT 1 NOT NULL,
    price_usd integer,
    price_loca integer,
    loca_bonus integer DEFAULT 0 NOT NULL,
    is_favorite boolean,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.package OWNER TO postgres;

--
-- Name: package_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.package_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.package_id_seq OWNER TO postgres;

--
-- Name: package_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.package_id_seq OWNED BY public.package.id;


--
-- Name: payment_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_log (
    id integer NOT NULL,
    topic character varying NOT NULL,
    type public.payment_log_type_enum NOT NULL,
    query character varying NOT NULL,
    body character varying,
    ip character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.payment_log OWNER TO postgres;

--
-- Name: payment_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payment_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payment_log_id_seq OWNER TO postgres;

--
-- Name: payment_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payment_log_id_seq OWNED BY public.payment_log.id;


--
-- Name: permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permission (
    name character varying NOT NULL,
    key character varying,
    code integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.permission OWNER TO postgres;

--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role (
    id integer NOT NULL,
    name character varying NOT NULL,
    status boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.role OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_id_seq OWNER TO postgres;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;


--
-- Name: role_permissions_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions_permission (
    role_id integer NOT NULL,
    premission_code integer NOT NULL
);


ALTER TABLE public.role_permissions_permission OWNER TO postgres;

--
-- Name: standard_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.standard_price (
    id integer NOT NULL,
    price integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.standard_price OWNER TO postgres;

--
-- Name: standard_price_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.standard_price_history (
    id integer NOT NULL,
    price_before integer,
    price_after integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    "userId" integer
);


ALTER TABLE public.standard_price_history OWNER TO postgres;

--
-- Name: standard_price_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.standard_price_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.standard_price_history_id_seq OWNER TO postgres;

--
-- Name: standard_price_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.standard_price_history_id_seq OWNED BY public.standard_price_history.id;


--
-- Name: standard_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.standard_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.standard_price_id_seq OWNER TO postgres;

--
-- Name: standard_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.standard_price_id_seq OWNED BY public.standard_price.id;


--
-- Name: third_party; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.third_party (
    name character varying NOT NULL,
    client_id character varying NOT NULL,
    client_secret character varying NOT NULL
);


ALTER TABLE public.third_party OWNER TO postgres;

--
-- Name: transaction_loca_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction_loca_history (
    id integer NOT NULL,
    package_id integer,
    type character varying NOT NULL,
    loca integer NOT NULL,
    receiver_id integer,
    sender_id integer,
    status character varying DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.transaction_loca_history OWNER TO postgres;

--
-- Name: transaction_loca_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_loca_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_loca_history_id_seq OWNER TO postgres;

--
-- Name: transaction_loca_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_loca_history_id_seq OWNED BY public.transaction_loca_history.id;


--
-- Name: transaction_locabonus_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction_locabonus_history (
    id integer NOT NULL,
    sender_id integer,
    receiver_id integer,
    loca_bonus double precision NOT NULL,
    log_loca_bonus_id integer,
    type character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.transaction_locabonus_history OWNER TO postgres;

--
-- Name: transaction_locabonus_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_locabonus_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_locabonus_history_id_seq OWNER TO postgres;

--
-- Name: transaction_locabonus_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_locabonus_history_id_seq OWNED BY public.transaction_locabonus_history.id;


--
-- Name: transaction_point_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction_point_history (
    id integer NOT NULL,
    account_number character varying NOT NULL,
    account_name character varying NOT NULL,
    account_branch character varying,
    point integer NOT NULL,
    status character varying DEFAULT 'PENDING'::character varying NOT NULL,
    type character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    user_id integer,
    bank_id integer
);


ALTER TABLE public.transaction_point_history OWNER TO postgres;

--
-- Name: transaction_point_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_point_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_point_history_id_seq OWNER TO postgres;

--
-- Name: transaction_point_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_point_history_id_seq OWNED BY public.transaction_point_history.id;


--
-- Name: transaction_transfer_point_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaction_transfer_point_history (
    id integer NOT NULL,
    type character varying NOT NULL,
    usd integer NOT NULL,
    status character varying DEFAULT 'PENDING'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    receiver_id integer,
    send_id integer
);


ALTER TABLE public.transaction_transfer_point_history OWNER TO postgres;

--
-- Name: transaction_transfer_point_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_transfer_point_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transaction_transfer_point_history_id_seq OWNER TO postgres;

--
-- Name: transaction_transfer_point_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transaction_transfer_point_history_id_seq OWNED BY public.transaction_transfer_point_history.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying NOT NULL,
    phone_number character varying,
    full_name character varying,
    level integer DEFAULT 0 NOT NULL,
    agency_level integer DEFAULT 0 NOT NULL,
    company_level integer,
    company_id integer,
    password character varying,
    identification_number character varying,
    identification_created_at timestamp without time zone,
    identification_created_from character varying,
    province character varying,
    province_id integer,
    district character varying,
    district_id integer,
    address character varying,
    active boolean DEFAULT true NOT NULL,
    code character varying NOT NULL,
    referred_code character varying,
    path character varying,
    type public.user_type_enum DEFAULT 'customer'::public.user_type_enum NOT NULL,
    refresh_token character varying,
    locamos_access_token character varying,
    ref_user_id integer,
    is_kyc_verified boolean DEFAULT false NOT NULL,
    identification_befor_img character varying,
    identification_after_img character varying,
    profile_img character varying,
    date_ykc timestamp without time zone,
    role_id integer,
    created_by_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    bank integer,
    account_number character varying,
    account_name character varying,
    account_branch character varying,
    status_kyc public.user_status_kyc_enum DEFAULT 'PENDING'::public.user_status_kyc_enum NOT NULL,
    info integer,
    wallet integer
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: user_package; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_package (
    id integer NOT NULL,
    ref_id character varying NOT NULL,
    user_id integer NOT NULL,
    package_id integer NOT NULL,
    package_name character varying NOT NULL,
    quantity integer NOT NULL,
    remaining_quantity integer NOT NULL,
    price integer NOT NULL,
    promotion double precision,
    loca_bonus integer DEFAULT 0 NOT NULL,
    price_usd integer,
    paid_at timestamp without time zone,
    purchase_status public.user_package_purchase_status_enum DEFAULT 'unauthorized'::public.user_package_purchase_status_enum NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    created_by_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    contract_id integer
);


ALTER TABLE public.user_package OWNER TO postgres;

--
-- Name: user_package_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_package_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_package_id_seq OWNER TO postgres;

--
-- Name: user_package_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_package_id_seq OWNED BY public.user_package.id;


--
-- Name: wallet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallet (
    id integer NOT NULL,
    total integer DEFAULT 0 NOT NULL,
    usd integer DEFAULT 0 NOT NULL,
    nal integer DEFAULT 0 NOT NULL,
    nft integer DEFAULT 0 NOT NULL,
    loca integer DEFAULT 0 NOT NULL,
    loca_bonus integer DEFAULT 0 NOT NULL,
    spent integer DEFAULT 0 NOT NULL,
    spent_company integer DEFAULT 0 NOT NULL,
    token character varying,
    version integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.wallet OWNER TO postgres;

--
-- Name: wallet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.wallet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wallet_id_seq OWNER TO postgres;

--
-- Name: wallet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.wallet_id_seq OWNED BY public.wallet.id;


--
-- Name: bank id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank ALTER COLUMN id SET DEFAULT nextval('public.bank_id_seq'::regclass);


--
-- Name: bill id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bill ALTER COLUMN id SET DEFAULT nextval('public.bill_id_seq'::regclass);


--
-- Name: city id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city ALTER COLUMN id SET DEFAULT nextval('public.city_id_seq'::regclass);


--
-- Name: commission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commission ALTER COLUMN id SET DEFAULT nextval('public.commission_id_seq'::regclass);


--
-- Name: commission_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commission_history ALTER COLUMN id SET DEFAULT nextval('public.commission_history_id_seq'::regclass);


--
-- Name: contract id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract ALTER COLUMN id SET DEFAULT nextval('public.contract_id_seq'::regclass);


--
-- Name: contract_location id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contract_location ALTER COLUMN id SET DEFAULT nextval('public.contract_location_id_seq'::regclass);


--
-- Name: district id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.district ALTER COLUMN id SET DEFAULT nextval('public.district_id_seq'::regclass);


--
-- Name: info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.info ALTER COLUMN id SET DEFAULT nextval('public.info_id_seq'::regclass);


--
-- Name: level id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.level ALTER COLUMN id SET DEFAULT nextval('public.level_id_seq'::regclass);


--
-- Name: level_company id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.level_company ALTER COLUMN id SET DEFAULT nextval('public.level_company_id_seq'::regclass);


--
-- Name: level_company_pending id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.level_company_pending ALTER COLUMN id SET DEFAULT nextval('public.level_company_pending_id_seq'::regclass);


--
-- Name: location id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.location ALTER COLUMN id SET DEFAULT nextval('public.location_id_seq'::regclass);


--
-- Name: lock_zone id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lock_zone ALTER COLUMN id SET DEFAULT nextval('public.lock_zone_id_seq'::regclass);


--
-- Name: log_loca_bonus id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_loca_bonus ALTER COLUMN id SET DEFAULT nextval('public.log_loca_bonus_id_seq'::regclass);


--
-- Name: log_update_wallet3rd id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_update_wallet3rd ALTER COLUMN id SET DEFAULT nextval('public.log_update_wallet3rd_id_seq'::regclass);


--
-- Name: manage_price_by_date id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manage_price_by_date ALTER COLUMN id SET DEFAULT nextval('public.manage_price_by_date_id_seq'::regclass);


--
-- Name: manage_price_by_routine id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manage_price_by_routine ALTER COLUMN id SET DEFAULT nextval('public.manage_price_by_routine_id_seq'::regclass);


--
-- Name: manage_price_package id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manage_price_package ALTER COLUMN id SET DEFAULT nextval('public.manage_price_package_id_seq'::regclass);


--
-- Name: notify id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notify ALTER COLUMN id SET DEFAULT nextval('public.notify_id_seq'::regclass);


--
-- Name: order id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."order" ALTER COLUMN id SET DEFAULT nextval('public.order_id_seq'::regclass);


--
-- Name: package id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.package ALTER COLUMN id SET DEFAULT nextval('public.package_id_seq'::regclass);


--
-- Name: payment_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_log ALTER COLUMN id SET DEFAULT nextval('public.payment_log_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);


--
-- Name: standard_price id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standard_price ALTER COLUMN id SET DEFAULT nextval('public.standard_price_id_seq'::regclass);


--
-- Name: standard_price_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.standard_price_history ALTER COLUMN id SET DEFAULT nextval('public.standard_price_history_id_seq'::regclass);


--
-- Name: transaction_loca_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_loca_history ALTER COLUMN id SET DEFAULT nextval('public.transaction_loca_history_id_seq'::regclass);


--
-- Name: transaction_locabonus_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_locabonus_history ALTER COLUMN id SET DEFAULT nextval('public.transaction_locabonus_history_id_seq'::regclass);


--
-- Name: transaction_point_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_point_history ALTER COLUMN id SET DEFAULT nextval('public.transaction_point_history_id_seq'::regclass);


--
-- Name: transaction_transfer_point_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaction_transfer_point_history ALTER COLUMN id SET DEFAULT nextval('public.transaction_transfer_point_history_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: user_package id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_package ALTER COLUMN id SET DEFAULT nextval('public.user_package_id_seq'::regclass);


--
-- Name: wallet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet ALTER COLUMN id SET DEFAULT nextval('public.wallet_id_seq'::regclass);


--
-- Data for Name: bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bank (id, name, short_name, logo) FROM stdin;
12	Ng??n h??ng TMCP Ph??t tri???n Th??nh ph??? H??? Ch?? Minh	HDBank	https://api.vietqr.io/img/HDB.png
17	Ng??n h??ng TMCP C??ng th????ng Vi???t Nam	VietinBank	https://api.vietqr.io/img/ICB.png
43	Ng??n ha??ng TMCP Ngoa??i Th????ng Vi????t Nam	Vietcombank	https://api.vietqr.io/img/VCB.png
4	Ng??n h??ng TMCP ?????u t?? v?? Ph??t tri???n Vi???t Nam	BIDV	https://api.vietqr.io/img/BIDV.png
42	Ng??n h??ng N??ng nghi???p v?? Ph??t tri???n N??ng th??n Vi???t Nam	Agribank	https://api.vietqr.io/img/VBA.png
26	Ng??n h??ng TMCP Ph????ng ????ng	OCB	https://api.vietqr.io/img/OCB.png
21	Ng??n h??ng TMCP Qu??n ?????i	MBBank	https://api.vietqr.io/img/MB.png
38	Ng??n h??ng TMCP K??? th????ng Vi???t Nam	Techcombank	https://api.vietqr.io/img/TCB.png
2	Ng??n h??ng TMCP ?? Ch??u	ACB	https://api.vietqr.io/img/ACB.png
47	Ng??n h??ng TMCP Vi???t Nam Th???nh V?????ng	VPBank	https://api.vietqr.io/img/VPB.png
39	Ng??n h??ng TMCP Ti??n Phong	TPBank	https://api.vietqr.io/img/TPB.png
36	Ng??n h??ng TMCP S??i G??n Th????ng T??n	Sacombank	https://api.vietqr.io/img/STB.png
44	Ng??n ha??ng TMCP Ba??n Vi????t	VietCapitalBank	https://api.vietqr.io/img/VCCB.png
31	Ng??n h??ng TMCP S??i G??n	SCB	https://api.vietqr.io/img/SCB.png
45	Ng??n ha??ng TMCP Qu???c t??? Vi???t Nam	VIB	https://api.vietqr.io/img/VIB.png
35	Ng??n h??ng TMCP S??i G??n - H?? N???i	SHB	https://api.vietqr.io/img/SHB.png
10	Ng??n h??ng TMCP Xu???t Nh???p kh???u Vi???t Nam	Eximbank	https://api.vietqr.io/img/EIB.png
22	Ng??n ha??ng TMCP Ha??ng Ha??i	MSB	https://api.vietqr.io/img/MSB.png
53	TMCP Vi???t Nam Th???nh V?????ng - Ng??n h??ng s??? CAKE by VPBank	CAKE	https://api.vietqr.io/img/CAKE.png
54	TMCP Vi???t Nam Th???nh V?????ng - Ng??n h??ng s??? Ubank by VPBank	Ubank	https://api.vietqr.io/img/UBANK.png
57	Viettel Money	ViettelMoney	https://api.vietqr.io/img/VIETTELMONEY.png
56	VNPT Money	VNPTMoney	https://api.vietqr.io/img/VNPTMONEY.png
34	Ng??n h??ng TMCP S??i G??n C??ng Th????ng	SaigonBank	https://api.vietqr.io/img/SGICB.png
3	Ng??n h??ng TMCP B???c ??	BacABank	https://api.vietqr.io/img/BAB.png
30	Ng??n ha??ng TMCP ??a??i Chu??ng Vi????t Nam	PVcomBank	https://api.vietqr.io/img/PVCB.png
27	Ng??n h??ng Th????ng m???i TNHH MTV ?????i D????ng	Oceanbank	https://api.vietqr.io/img/OCEANBANK.png
24	Ng??n h??ng TMCP Qu???c D??n	NCB	https://api.vietqr.io/img/NCB.png
37	Ng??n h??ng TNHH MTV Shinhan Vi???t Nam	ShinhanBank	https://api.vietqr.io/img/SHBVN.png
1	Ng??n h??ng TMCP An B??nh	ABBANK	https://api.vietqr.io/img/ABB.png
41	Ng??n h??ng TMCP Vi???t ??	VietABank	https://api.vietqr.io/img/VAB.png
23	Ng??n h??ng TMCP Nam ??	NamABank	https://api.vietqr.io/img/NAB.png
29	Ng??n h??ng TMCP X??ng d???u Petrolimex	PGBank	https://api.vietqr.io/img/PGB.png
46	Ng??n h??ng TMCP Vi???t Nam Th????ng T??n	VietBank	https://api.vietqr.io/img/VIETBANK.png
5	Ng??n h??ng TMCP B???o Vi???t	BaoVietBank	https://api.vietqr.io/img/BVB.png
33	Ng??n ha??ng TMCP ????ng Nam A??	SeABank	https://api.vietqr.io/img/SEAB.png
52	Ng??n h??ng H???p t??c x?? Vi???t Nam	COOPBANK	https://api.vietqr.io/img/COOPBANK.png
20	Ng??n h??ng TMCP B??u ??i???n Li??n Vi???t	LienVietPostBank	https://api.vietqr.io/img/LPB.png
19	Ng??n h??ng TMCP Ki??n Long	KienLongBank	https://api.vietqr.io/img/KLB.png
55	Ng??n h??ng ?????i ch??ng TNHH Kasikornbank	KBank	https://api.vietqr.io/img/KBANK.png
48	Ng??n h??ng Li??n doanh Vi???t - Nga	VRB	https://api.vietqr.io/img/VRB.png
32	Ng??n h??ng TNHH MTV Standard Chartered Bank Vi???t Nam	StandardChartered	https://api.vietqr.io/img/SCVN.png
25	Ng??n h??ng Nonghyup - Chi nh??nh H?? N???i	Nonghyup	https://api.vietqr.io/img/NHB.png
18	Ng??n h??ng TNHH Indovina	IndovinaBank	https://api.vietqr.io/img/IVB.png
16	Ng??n ha??ng C??ng nghi????p Ha??n Qu????c - Chi nha??nh TP. H???? Chi?? Minh	IBKHCM	https://api.vietqr.io/img/IBK.png
51	Ng??n h??ng Kookmin - Chi nh??nh Th??nh ph??? H??? Ch?? Minh	KookminHCM	https://api.vietqr.io/img/KBHCM.png
50	Ng??n h??ng Kookmin - Chi nh??nh H?? N???i	KookminHN	https://api.vietqr.io/img/KBHN.png
49	Ng??n h??ng TNHH MTV Woori Vi???t Nam	Woori	https://api.vietqr.io/img/WVN.png
14	Ng??n h??ng TNHH MTV HSBC (Vi???t Nam)	HSBC	https://api.vietqr.io/img/HSBC.png
6	Ng??n h??ng Th????ng m???i TNHH MTV X??y d???ng Vi???t Nam	CBBank	https://api.vietqr.io/img/CBB.png
15	Ng??n ha??ng C??ng nghi????p Ha??n Qu????c - Chi nha??nh Ha?? N????i	IBKHN	https://api.vietqr.io/img/IBK.png
7	Ng??n h??ng TNHH MTV CIMB Vi???t Nam	CIMB	https://api.vietqr.io/img/CIMB.png
8	DBS Bank Ltd - Chi nh??nh Th??nh ph??? H??? Ch?? Minh	DBSBank	https://api.vietqr.io/img/DBS.png
9	Ng??n h??ng TMCP ????ng ??	DongABank	https://api.vietqr.io/img/DOB.png
11	Ng??n h??ng Th????ng m???i TNHH MTV D???u Kh?? To??n C???u	GPBank	https://api.vietqr.io/img/GPB.png
28	Ng??n h??ng TNHH MTV Public Vi???t Nam	PublicBank	https://api.vietqr.io/img/PBVN.png
40	Ng??n h??ng United Overseas - Chi nh??nh TP. H??? Ch?? Minh	UnitedOverseas	https://api.vietqr.io/img/UOB.png
13	Ng??n h??ng TNHH MTV Hong Leong Vi???t Nam	HongLeong	https://api.vietqr.io/img/HLBVN.png
\.


--
-- Data for Name: bill; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bill (id, ref_id, order_id, status, vendor, invoice_number, version, created_by_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: city; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.city (id, name) FROM stdin;
1	H??? Ch?? Minh
2	Ha?? N????i
3	???? N???ng
4	B??nh D????ng
5	?????ng Nai
6	Kh??nh H??a
7	H???i Ph??ng
8	Long An
9	Qu???ng Nam
10	B?? R???a V??ng T??u
11	?????k L???k
12	C???n Th??
13	B??nh Thu???n  
14	L??m ?????ng
15	Th???a Thi??n Hu???
16	Ki??n Giang
17	B???c Ninh
18	Qu???ng Ninh
19	Thanh H??a
20	Ngh??? An
21	H???i D????ng
22	Gia Lai
23	B??nh Ph?????c
24	H??ng Y??n
25	B??nh ?????nh
26	Ti???n Giang
27	Th??i B??nh
28	B???c Giang
29	H??a B??nh
30	An Giang
31	V??nh Ph??c
32	T??y Ninh
33	Th??i Nguy??n
34	L??o Cai
35	Nam ?????nh
36	Qu???ng Ng??i
37	B???n Tre
38	?????k N??ng
39	C?? Mau
40	V??nh Long
41	Ninh B??nh
42	Ph?? Th???
43	Ninh Thu???n
44	Ph?? Y??n
45	H?? Nam
46	H?? T??nh
47	?????ng Th??p
48	S??c Tr??ng
49	Kon Tum
50	Qu???ng B??nh
51	Qu???ng Tr???
52	Tr?? Vinh
53	H???u Giang
54	S??n La
55	B???c Li??u
56	Y??n B??i
57	Tuy??n Quang
58	??i???n Bi??n
59	Lai Ch??u
60	L???ng S??n
61	H?? Giang
62	B???c K???n
63	Cao B???ng
\.


--
-- Data for Name: commission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commission (id, direct_commission, weekly_commission, monthly_commission, group_commission) FROM stdin;
1	15	5	2	10
\.


--
-- Data for Name: commission_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.commission_history (id, type, transaction, transaction_owner_id, transaction_amount, percentage, commission, order_id, commission_receiver_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: contract; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract (id, buyer_id, owner_id, name, email, phone, identification_number, identification_created_from, identification_created_at, address) FROM stdin;
\.


--
-- Data for Name: contract_location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contract_location (id, link_soft, link_pdf, link_certification, contract_id, user_id, location_id, link_signature) FROM stdin;
\.


--
-- Data for Name: district; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.district (id, name, city) FROM stdin;
1	B??nh Ch??nh	1
2	B??nh T??n	1
3	B??nh Th???nh	1
4	C???n Gi???	1
5	C??? Chi	1
6	G?? V???p	1
7	H??c M??n	1
8	Nh?? B??	1
9	Ph?? Nhu???n	1
10	Qu???n 1	1
11	Qu???n 10	1
12	Qu???n 11	1
13	Qu???n 12	1
14	Qu???n 2	1
15	Qu???n 3	1
16	Qu???n 4	1
17	Qu???n 5	1
18	Qu???n 6	1
19	Qu???n 7	1
20	Qu???n 8	1
21	Qu???n 9	1
22	T??n B??nh	1
23	T??n Ph??	1
24	Th??? ?????c	1
25	Ba ????nh	2
26	Ba V??	2
27	B???c T??? Li??m	2
28	C???u Gi???y	2
29	Ch????ng M???	2
30	??an Ph?????ng	2
31	????ng Anh	2
32	?????ng ??a	2
33	Gia L??m	2
34	H?? ????ng	2
35	Hai B?? Tr??ng	2
36	Ho??i ?????c	2
37	Ho??n Ki???m	2
38	Ho??ng Mai	2
39	Long Bi??n	2
40	M?? Linh	2
41	M??? ?????c	2
42	Nam T??? Li??m	2
43	Ph?? Xuy??n	2
44	Ph??c Th???	2
45	Qu???c Oai	2
46	S??c S??n	2
47	S??n T??y	2
48	T??y H???	2
49	Th???ch Th???t	2
50	Thanh Oai	2
51	Thanh Tr??	2
52	Thanh Xu??n	2
53	Th?????ng T??n	2
54	???ng H??a	2
55	C???m L???	3
56	H???i Ch??u	3
57	H??a Vang	3
58	Ho??ng Sa	3
59	Li??n Chi???u	3
60	Ng?? H??nh S??n	3
61	S??n Tr??	3
62	Thanh Kh??	3
63	B??u B??ng	4
64	B???n C??t	4
65	D???u Ti???ng	4
66	D?? An	4
67	Ph?? Gi??o	4
68	T??n Uy??n	4
69	Th??? D???u M???t	4
70	Thu???n An	4
71	Bi??n H??a	5
72	C???m M???	5
73	?????nh Qu??n	5
74	Long Kh??nh	5
75	Long Th??nh	5
76	Nh??n Tr???ch	5
77	T??n Ph??	5
78	Th???ng Nh???t	5
79	Tr???ng Bom	5
80	V??nh C???u	5
81	Xu??n L???c	5
82	Cam L??m	6
83	Cam Ranh	6
84	Di??n Kh??nh	6
85	Kh??nh S??n	6
86	Kh??nh V??nh	6
87	Nha Trang	6
88	Ninh H??a	6
89	Tr?????ng Sa	6
90	V???n Ninh	6
91	An D????ng	7
92	An L??o	7
93	B???ch Long V??	7
94	C??t H???i	7
97	H???i An	7
98	H???ng B??ng	7
99	Ki???n An	7
100	Ki???n Th???y	7
101	L?? Ch??n	7
102	Ng?? Quy???n	7
103	Th???y Nguy??n	7
104	Ti??n L??ng	7
105	V??nh B???o	7
106	B???n L???c	8
107	C???n ???????c	8
108	C???n Giu???c	8
109	Ch??u Th??nh	8
110	?????c H??a	8
111	?????c Hu???	8
112	Ki???n T?????ng	8
113	M???c H??a	8
114	T??n An	8
115	T??n H??ng	8
116	T??n Th???nh	8
117	T??n Tr???	8
118	Th???nh H??a	8
119	Th??? Th???a	8
120	V??nh H??ng	8
121	B???c Tr?? My	9
126	Hi???p ?????c	9
127	H???i An	9
128	Nam Giang	9
129	Nam Tr?? My	9
130	N??ng S??n	9
131	N??i Th??nh	9
132	Ph?? Ninh	9
133	Ph?????c S??n	9
134	Qu??? S??n	9
135	Tam K???	9
136	T??y Giang	9
137	Th??ng B??nh	9
138	Ti??n Ph?????c	9
139	B?? R???a	10
140	Ch??u ?????c	10
141	C??n ?????o	10
142	?????t ?????	10
143	Long ??i???n	10
144	T??n Th??nh	10
145	V??ng T??u	10
146	Xuy??n M???c	10
147	Bu??n ????n	11
148	Bu??n H???	11
149	Bu??n Ma Thu???t	11
150	C?? Kuin	11
151	C?? M'gar	11
152	Ea H'Leo	11
153	Ea Kar	11
154	Ea S??p	11
155	Kr??ng Ana	11
156	Kr??ng B??ng	11
157	Kr??ng Buk	11
158	Kr??ng N??ng	11
159	Kr??ng P???c	11
160	L??k	11
161	M'??r??k	11
162	 Th???i Lai	12
163	B??nh Th???y	12
164	C??i R??ng	12
165	C??? ?????	12
166	Ninh Ki???u	12
167	?? M??n	12
168	Phong ??i???n	12
169	Th???t N???t	12
170	V??nh Th???nh	12
171	B???c B??nh	13
172	?????o Ph?? Qu??	13
173	?????c Linh	13
174	H??m T??n	13
175	H??m Thu???n B???c	13
176	H??m Thu???n Nam	13
177	La Gi	13
178	Phan Thi???t	13
179	T??nh Linh	13
180	Tuy Phong	13
181	B???o L??m	14
182	B???o L???c	14
183	C??t Ti??n	14
189	????n D????ng	14
190	?????c Tr???ng	14
191	L???c D????ng	14
192	L??m H??	14
193	A L?????i	15
194	Hu???	15
195	H????ng Th???y	15
196	H????ng Tr??	15
197	Nam ????ng	15
198	Phong ??i???n	15
199	Ph?? L???c	15
200	Ph?? Vang	15
201	Qu???ng ??i???n	15
202	An Bi??n	16
203	An Minh	16
204	Ch??u Th??nh	16
205	Giang Th??nh	16
206	Gi???ng Ri???ng	16
207	G?? Quao	16
208	H?? Ti??n	16
209	H??n ?????t	16
210	Ki??n H???i	16
211	Ki??n L????ng	16
212	Ph?? Qu???c	16
213	R???ch Gi??	16
214	T??n Hi???p	16
215	U minh Th?????ng	16
216	V??nh Thu???n	16
217	B???c Ninh	17
218	Gia B??nh	17
219	L????ng T??i	17
220	Qu??? V??	17
221	Thu???n Th??nh	17
222	Ti??n Du	17
223	T??? S??n	17
224	Y??n Phong	17
225	Ba Ch???	18
226	B??nh Li??u	18
227	C???m Ph???	18
228	C?? T??	18
229	?????m H??	18
230	????ng Tri???u	18
231	H??? Long	18
232	H???i H??	18
233	Ho??nh B???	18
234	M??ng C??i	18
235	Qu???ng Y??n	18
236	Ti??n Y??n	18
237	U??ng B??	18
238	V??n ?????n	18
239	B?? Th?????c	19
240	B???m S??n	19
241	C???m Th???y	19
242	????ng S??n	19
243	H?? Trung	19
244	H???u L???c	19
245	Ho???ng H??a	19
246	Lang Ch??nh	19
247	M?????ng L??t	19
248	Nga S??n	19
249	Ng???c L???c	19
250	Nh?? Thanh	19
251	Nh?? Xu??n	19
252	N??ng C???ng	19
253	Quan H??a	19
254	Quan S??n	19
255	Qu???ng X????ng	19
256	S???m S??n	19
257	Th???ch Th??nh	19
258	Thanh H??a	19
259	Thi???u H??a	19
260	Th??? Xu??n	19
261	Th?????ng Xu??n	19
262	T??nh Gia	19
263	Tri???u S??n	19
264	V??nh L???c	19
265	Y??n ?????nh	19
266	Anh S??n	20
267	Con Cu??ng	20
268	C???a L??	20
269	Di???n Ch??u	20
270	???? L????ng	20
271	Ho??ng Mai	20
272	H??ng Nguy??n	20
273	K??? S??n	20
274	Nam ????n	20
275	Nghi L???c	20
276	Ngh??a ????n	20
277	Qu??? Phong	20
278	Qu??? Ch??u	20
279	Qu??? H???p	20
280	Qu???nh L??u	20
281	T??n K???	20
282	Th??i H??a	20
283	Thanh Ch????ng	20
284	T????ng D????ng	20
285	Vinh	20
286	Y??n Th??nh	20
287	B??nh Giang	21
288	C???m Gi??ng	21
289	Ch?? Linh	21
290	Gia L???c	21
291	H???i D????ng	21
292	Kim Th??nh	21
293	Kinh M??n	21
294	Nam S??ch	21
295	Ninh Giang	21
296	Thanh H??	21
297	Thanh Mi???n	21
298	T??? K???	21
299	An Kh??	22
300	AYun Pa	22
301	Ch?? P??h	22
302	Ch?? P??h	22
303	Ch?? S??	22
304	Ch??PR??ng	22
305	????k ??oa	22
306	????k P??	22
307	?????c C??	22
308	Ia Grai	22
309	Ia Pa	22
310	KBang	22
311	K??ng Chro	22
312	Kr??ng Pa	22
313	Mang Yang	22
314	Ph?? Thi???n	22
315	Plei Ku	22
316	B??nh Long	23
317	B?? ????ng	23
318	B?? ?????p	23
319	B?? Gia M???p	23
320	Ch??n Th??nh	23
321	?????ng Ph??	23
322	?????ng Xo??i	23
323	H???n Qu???n	23
324	L???c Ninh	23
325	Ph?? Ri???ng	23
326	Ph?????c Long	23
327	??n Thi	24
328	H??ng Y??n	24
329	Kho??i Ch??u	24
330	Kim ?????ng	24
331	M??? H??o	24
332	Ph?? C???	24
333	Ti??n L???	24
334	V??n Giang	24
335	V??n L??m	24
336	Y??n M???	24
337	An L??o	25
338	An Nh??n	25
339	Ho??i ??n	25
340	Ho??i Nh??n	25
341	Ph?? C??t	25
342	Ph?? M???	25
343	Quy Nh??n	25
344	T??y S??n	25
345	Tuy Ph?????c	25
346	V??n Canh	25
347	V??nh Th???nh	25
348	C??i B??	26
349	Cai L???y	26
350	Ch??u Th??nh	26
351	Ch??? G???o	26
352	G?? C??ng	26
353	G?? C??ng ????ng	26
354	G?? C??ng T??y	26
355	Huy???n Cai L???y	26
356	M??? Tho	26
357	T??n Ph?? ????ng	26
358	T??n Ph?????c	26
359	????ng H??ng	27
360	H??ng H??	27
361	Ki???n X????ng	27
362	Qu???nh Ph???	27
363	Th??i B??nh	27
364	Th??i Thu???	27
365	Ti???n H???i	27
366	V?? Th??	27
367	B???c Giang	28
368	Hi???p H??a	28
369	L???ng Giang	28
370	L???c Nam	28
371	L???c Ng???n	28
372	S??n ?????ng	28
373	T??n Y??n	28
374	Vi???t Y??n	28
375	Y??n D??ng	28
376	Y??n Th???	28
377	Cao Phong	29
378	???? B???c	29
379	H??a B??nh	29
380	Kim B??i	29
381	K??? S??n	29
382	L???c S??n	29
383	L???c Th???y	29
384	L????ng S??n	29
385	Mai Ch??u	29
386	T??n L???c	29
387	Y??n Th???y	29
388	An Ph??	30
389	Ch??u ?????c	30
390	Ch??u Ph??	30
391	Ch??u Th??nh	30
392	Ch??? M???i	30
393	Long Xuy??n	30
394	Ph?? T??n	30
395	T??n Ch??u	30
396	Tho???i S??n	30
397	T???nh Bi??n	30
398	Tri T??n	30
399	B??nh Xuy??n	31
400	L???p Th???ch	31
401	Ph??c Y??n	31
402	S??ng L??	31
405	V??nh T?????ng	31
406	V??nh Y??n	31
407	Y??n L???c	31
408	B???n C???u	32
409	Ch??u Th??nh	32
410	D????ng Minh Ch??u	32
411	G?? D???u	32
412	H??a Th??nh	32
413	T??n Bi??n	32
414	T??n Ch??u	32
415	T??y Ninh	32
416	Tr???ng B??ng	32
417	?????i T???	33
418	?????nh H??a	33
419	?????ng H???	33
420	Ph??? Y??n	33
421	Ph?? B??nh	33
422	Ph?? L????ng	33
423	S??ng C??ng	33
424	Th??i Nguy??n	33
425	V?? Nhai	33
426	B???c H??	34
427	B???o Th???ng	34
428	B???o Y??n	34
429	B??t X??t	34
430	L??o Cai	34
431	M?????ng Kh????ng	34
432	Sa Pa	34
433	V??n B??n	34
434	Xi Ma Cai	34
435	Giao Th???y	35
436	H???i H???u	35
437	M??? L???c	35
438	Nam ?????nh	35
439	Nam Tr???c	35
440	Ngh??a H??ng	35
441	Tr???c Ninh	35
442	V??? B???n	35
443	Xu??n Tr?????ng	35
444	?? Y??n	35
445	Ba T??	36
446	B??nh S??n	36
447	?????c Ph???	36
448	L?? S??n	36
449	Minh Long	36
450	M??? ?????c	36
451	Ngh??a H??nh	36
452	Qu???ng Ng??i	36
453	S??n H??	36
454	S??n T??y	36
455	S??n T???nh	36
456	T??y Tr??	36
457	Tr?? B???ng	36
458	T?? Ngh??a	36
459	Ba Tri	37
460	B???n Tre	37
461	B??nh ?????i	37
462	Ch??u Th??nh	37
463	Ch??? L??ch	37
464	Gi???ng Tr??m	37
465	M??? C??y B???c	37
466	M??? C??y Nam	37
467	Th???nh Ph??	37
468	C?? J??t	38
469	D??k GLong	38
470	D??k Mil	38
471	D??k R'L???p	38
472	D??k Song	38
473	Gia Ngh??a	38
474	Kr??ng N??	38
475	Tuy ?????c	38
476	C?? Mau	39
477	C??i N?????c	39
478	?????m D??i	39
479	N??m C??n	39
480	Ng???c Hi???n	39
481	Ph?? T??n	39
482	Th???i B??nh	39
483	Tr???n V??n Th???i	39
484	U Minh	39
485	B??nh Minh	40
486	B??nh T??n	40
487	Long H???	40
488	Mang Th??t	40
489	Tam B??nh	40
490	Tr?? ??n	40
491	V??nh Long	40
492	V??ng Li??m	40
493	Gia Vi???n	41
494	Hoa L??	41
495	Kim S??n	41
496	Nho Quan	41
497	Ninh B??nh	41
498	Tam ??i???p	41
499	Y??n Kh??nh	41
500	Y??n M??	41
501	C???m Kh??	42
502	??oan H??ng	42
503	H??? H??a	42
504	L??m Thao	42
505	Ph?? Ninh	42
506	Ph?? Th???	42
507	Tam N??ng	42
508	T??n S??n	42
509	Thanh Ba	42
510	Thanh S??n	42
511	Thanh Th???y	42
512	Vi???t Tr??	42
513	Y??n L???p	42
514	B??c ??i	43
515	Ninh H???i	43
516	Ninh Ph?????c	43
517	Ninh S??n	43
518	Phan Rang - Th??p Ch??m	43
519	Thu???n B???c	43
520	Thu???n Nam	43
521	????ng H??a	44
522	?????ng Xu??n	44
523	Ph?? H??a	44
524	S??n H??a	44
525	S??ng C???u	44
526	S??ng Hinh	44
527	T??y H??a	44
528	Tuy An	44
529	Tuy H??a	44
530	B??nh L???c	45
531	Duy Ti??n	45
532	Kim B???ng	45
533	L?? Nh??n	45
534	Ph??? L??	45
535	Thanh Li??m	45
536	C???m Xuy??n	46
537	Can L???c	46
538	?????c Th???	46
539	H?? T??nh	46
540	H???ng L??nh	46
541	H????ng Kh??	46
542	H????ng S??n	46
543	K??? Anh	46
544	L???c H??	46
545	Nghi Xu??n	46
546	Th???ch H??	46
547	V?? Quang	46
548	Cao L??nh	47
549	Ch??u Th??nh	47
550	H???ng Ng???	47
551	Huy???n Cao L??nh	47
552	Huy???n H???ng Ng???	47
553	Lai Vung	47
554	L???p V??	47
555	Sa ????c	47
556	Tam N??ng	47
557	T??n H???ng	47
558	Thanh B??nh	47
559	Th??p M?????i	47
560	Ch??u Th??nh	48
561	C?? Lao Dung	48
562	K??? S??ch	48
563	Long Ph??	48
564	M??? T??	48
565	M??? Xuy??n	48
566	Ng?? N??m	48
567	S??c Tr??ng	48
568	Th???nh Tr???	48
569	Tr???n ?????	48
570	V??nh Ch??u	48
571	????k Glei	49
572	????k H??	49
573	????k T??	49
574	Ia H'Drai	49
575	Kon Pl??ng	49
576	Kon R???y	49
577	KonTum	49
578	Ng???c H???i	49
579	Sa Th???y	49
580	Tu M?? R??ng	49
581	Ba ?????n	50
582	B??? Tr???ch	50
583	?????ng H???i	50
584	L??? Th???y	50
585	Minh H??a	50
586	Qu???ng Ninh	50
587	Qu???ng Tr???ch	50
588	Tuy??n H??a	50
589	Cam L???	51
590	??a Kr??ng	51
591	?????o C???n c???	51
592	????ng H??	51
593	Gio Linh	51
594	H???i L??ng	51
595	H?????ng H??a	51
596	Qu???ng Tr???	51
597	Tri???u Phong	51
598	V??nh Linh	51
599	C??ng Long	52
600	C???u K??	52
601	C???u Ngang	52
602	Ch??u Th??nh	52
603	Duy??n H???i	52
604	Ti???u C???n	52
605	Tr?? C??	52
606	Tr?? Vinh	52
607	Ch??u Th??nh	53
608	Ch??u Th??nh A	53
609	Long M???	53
610	Ng?? B???y	53
611	Ph???ng Hi???p	53
612	V??? Thanh	53
613	V??? Th???y	53
614	B???c Y??n	54
615	Mai S??n	54
616	M???c Ch??u	54
617	M?????ng La	54
618	Ph?? Y??n	54
619	Qu???nh Nhai	54
620	S??n La	54
621	S??ng M??	54
622	S???p C???p	54
623	Thu???n Ch??u	54
624	V??n H???	54
625	Y??n Ch??u	54
626	B???c Li??u	55
627	????ng H???i	55
628	Gi?? Rai	55
629	H??a B??nh	55
630	H???ng D??n	55
631	Ph?????c Long	55
632	V??nh L???i	55
633	L???c Y??n	56
634	M?? Cang Ch???i	56
635	Ngh??a L???	56
636	Tr???m T???u	56
637	Tr???n Y??n	56
638	V??n Ch???n	56
639	V??n Y??n	56
640	Y??n B??i	56
641	Y??n B??nh	56
642	Chi??m H??a	57
643	H??m Y??n	57
644	L??m B??nh	57
645	Na Hang	57
646	S??n D????ng	57
647	Tuy??n Quang	57
648	Y??n S??n	57
649	??i???n Bi??n	58
650	??i???n Bi??n ????ng	58
651	??i???n Bi??n Ph???	58
652	M?????ng ???ng	58
653	M?????ng Ch??	58
654	M?????ng Lay	58
655	M?????ng Nh??	58
656	N???m P???	58
657	T???a Ch??a	58
658	Tu???n Gi??o	58
659	Lai Ch??u	59
660	M?????ng T??	59
661	N???m Nh??n	59
662	Phong Th???	59
663	S??n H???	59
664	Tam ???????ng	59
665	T??n Uy??n	59
666	Than Uy??n	59
667	B???c S??n	60
668	B??nh Gia	60
669	Cao L???c	60
670	Chi L??ng	60
671	????nh L???p	60
672	H???u L??ng	60
673	L???ng S??n	60
674	L???c B??nh	60
675	Tr??ng ?????nh	60
676	V??n L??ng	60
677	V??n Quan	60
678	B???c M??	61
679	B???c Quang	61
680	?????ng V??n	61
681	H?? Giang	61
682	Ho??ng Su Ph??	61
683	M??o V???c	61
684	Qu???n B???	61
685	Quang B??nh	61
686	V??? Xuy??n	61
687	X??n M???n	61
688	Y??n Minh	61
689	Ba B???	62
690	B???c K???n	62
691	B???ch Th??ng	62
692	Ch??? ?????n	62
693	Ch??? M???i	62
694	Na R??	62
695	Ng??n S??n	62
696	P??c N???m	62
697	B???o L???c	63
698	B???o L??m	63
699	Cao B???ng	63
700	H??? Lang	63
701	H?? Qu???ng	63
702	H??a An	63
703	Nguy??n B??nh	63
704	Ph???c H??a	63
705	Qu???ng Uy??n	63
706	Th???ch An	63
707	Th??ng N??ng	63
708	Tr?? L??nh	63
709	Tr??ng Kh??nh	63
96	D????ng Kinh	7
95	????? S??n	7
125	Duy Xuy??n	9
122	?????i L???c	9
123	??i???n B??n	9
124	????ng Giang	9
188	Di Linh	14
184	????? Huoai	14
185	???? L???t	14
186	????? T???h	14
187	??am R??ng	14
404	Tam D????ng	31
403	Tam ?????o	31
\.


--
-- Data for Name: info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.info (id, address, aff_link, agency, birthday, code, email, is_email_verified, is_phone_verified, phone, name, kyc_state, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: job_register; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.job_register (name, is_process) FROM stdin;
PaymentService-clearPaymentLog	f
CommissionUpdateService-weekly	f
CommissionUpdateService-monthly	f
PaymentService-reSync	f
IncreaseLocaBonusService-weekly	f
\.


--
-- Data for Name: level; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.level (id, level_name, min_income, min_branch, min_top3_income, shared_commission) FROM stdin;
\.


--
-- Data for Name: level_company; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.level_company (id, level_name, commission, f1_qualified, min_kpi) FROM stdin;
1	CTV	0	0	0
2	N??T	0	0	0
3	Chuy??n vi??n	5	1	0
4	Qu???n l??	6	5	20
5	Tr?????ng ph??ng	4	3	0
6	Ph?? gi??m ?????c	4	5	0
7	Gi??m ?????c	5	0	0
8	CEO	2	0	0
\.


--
-- Data for Name: level_company_pending; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.level_company_pending (id, user_id, created_at, level_pending, status) FROM stdin;
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location (id, name, handle, map_captured, long, lat, safe_zone_top, safe_zone_bot, safe_zone_left, safe_zone_right, type, status, purchase_status, nft_status, is_blacklist, block_radius, country, province, district, commune, street, token_id, user_full_name, approved_by_id, approved_at, paid_at, version, contrac_id, created_at, updated_at, deleted_at, bsc_scan_link, user_id, user_name_owner, created_by_id) FROM stdin;
\.


--
-- Data for Name: location_handle; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.location_handle (name, total) FROM stdin;
\.


--
-- Data for Name: lock_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lock_zone (id, "timeStart", name, "timeEnd", type, district_id, province_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: log_loca_bonus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_loca_bonus (id, loca_bonus, user_id, sender_id, loca_bonus_remaining, order_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: log_update_wallet3rd; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_update_wallet3rd (id, user_id, loca, usd, note, client_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: manage_price_by_date; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manage_price_by_date (id, start_date, end_date, active, price, created_by, updated_by) FROM stdin;
\.


--
-- Data for Name: manage_price_by_routine; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manage_price_by_routine (id, type, days_of_week, weeks_of_month, months, repeat, active, price, created_by, updated_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: manage_price_package; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manage_price_package (id, type, price, price_id) FROM stdin;
1		680	0
2		680	0
3		680	0
4		680	0
5		680	0
6		680	0
7		680	0
8		680	0
9		680	0
10		680	0
11		680	0
12		680	0
13		680	0
14		680	0
15		680	0
16		680	0
17		680	0
18		680	0
19		680	0
20		680	0
21		680	0
22		680	0
23		680	0
24		680	0
25		680	0
26		680	0
27		680	0
\.


--
-- Data for Name: notify; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notify (id, title, "timeStart", type, conten, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."order" (id, payment_type, payment_status, price, note, location_id, user_package_id, version, quantity, created_by_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: package; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.package (id, ref_id, name, quantity, promotion, discount, version, price_usd, price_loca, loca_bonus, is_favorite, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: payment_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_log (id, topic, type, query, body, ip, created_at) FROM stdin;
\.


--
-- Data for Name: permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permission (name, key, code, created_at, updated_at) FROM stdin;
Xem danh s??ch NFT ?????a ??i???m	LOCATION	1	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
S???a, x??a, th??m m???i danh s??ch NFT ?????a ??i???m	LOCATION	2	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duy???t NFT ?????a ??i???m	LOCATION	24	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem gi?? NFT	PRICE_LOCATION	3	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
S???a, x??a gi?? NFT	PRICE_LOCATION	4	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem ????n mua combo	COMBO	5	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
S???a, x??a, th??m m???i ????n mua combo	COMBO	6	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem t??i kho???n ADMIN	ADMIN	7	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
S???a, x??a, th??m m???i t??i kho???n ADMIN	ADMIN	8	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duy???t t??i kho???n ADMIN	ADMIN	9	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem nh??m ph??n quy???n	ROLE	10	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
S???a, x??a, th??m m???i nh??m ph??n quy???n	ROLE	11	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duy???t nh??m ph??n quy???n	ROLE	12	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem kh??ch h??ng	CUSTOMER	13	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
S???a, x??a, th??m m???i kh??ch h??ng	CUSTOMER	14	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duy???t kh??ch h??ng	CUSTOMER	15	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem KYC	KYC	16	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duy???t KYC	KYC	17	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem giao d???ch ti???n & LOCA	LOCA	18	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
S???a, x??a, th??m m???i giao d???ch ti???n & LOCA	LOCA	19	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem th??ng b??o MAIL/SMS	NOTIFY	20	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
S???a, x??a, th??m th??ng b??o MAIL/SMS	NOTIFY	21	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem c???u h??nh h??? th???ng	SYSTEM	22	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
S???a, x??a, th??m c???u h??nh h??? th???ng 	SYSTEM	23	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role (id, name, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: role_permissions_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_