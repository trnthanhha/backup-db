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
    transaction character varying DEFAULT 'Thực hiện thanh toán'::character varying NOT NULL,
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
12	Ngân hàng TMCP Phát triển Thành phố Hồ Chí Minh	HDBank	https://api.vietqr.io/img/HDB.png
17	Ngân hàng TMCP Công thương Việt Nam	VietinBank	https://api.vietqr.io/img/ICB.png
43	Ngân hàng TMCP Ngoại Thương Việt Nam	Vietcombank	https://api.vietqr.io/img/VCB.png
4	Ngân hàng TMCP Đầu tư và Phát triển Việt Nam	BIDV	https://api.vietqr.io/img/BIDV.png
42	Ngân hàng Nông nghiệp và Phát triển Nông thôn Việt Nam	Agribank	https://api.vietqr.io/img/VBA.png
26	Ngân hàng TMCP Phương Đông	OCB	https://api.vietqr.io/img/OCB.png
21	Ngân hàng TMCP Quân đội	MBBank	https://api.vietqr.io/img/MB.png
38	Ngân hàng TMCP Kỹ thương Việt Nam	Techcombank	https://api.vietqr.io/img/TCB.png
2	Ngân hàng TMCP Á Châu	ACB	https://api.vietqr.io/img/ACB.png
47	Ngân hàng TMCP Việt Nam Thịnh Vượng	VPBank	https://api.vietqr.io/img/VPB.png
39	Ngân hàng TMCP Tiên Phong	TPBank	https://api.vietqr.io/img/TPB.png
36	Ngân hàng TMCP Sài Gòn Thương Tín	Sacombank	https://api.vietqr.io/img/STB.png
44	Ngân hàng TMCP Bản Việt	VietCapitalBank	https://api.vietqr.io/img/VCCB.png
31	Ngân hàng TMCP Sài Gòn	SCB	https://api.vietqr.io/img/SCB.png
45	Ngân hàng TMCP Quốc tế Việt Nam	VIB	https://api.vietqr.io/img/VIB.png
35	Ngân hàng TMCP Sài Gòn - Hà Nội	SHB	https://api.vietqr.io/img/SHB.png
10	Ngân hàng TMCP Xuất Nhập khẩu Việt Nam	Eximbank	https://api.vietqr.io/img/EIB.png
22	Ngân hàng TMCP Hàng Hải	MSB	https://api.vietqr.io/img/MSB.png
53	TMCP Việt Nam Thịnh Vượng - Ngân hàng số CAKE by VPBank	CAKE	https://api.vietqr.io/img/CAKE.png
54	TMCP Việt Nam Thịnh Vượng - Ngân hàng số Ubank by VPBank	Ubank	https://api.vietqr.io/img/UBANK.png
57	Viettel Money	ViettelMoney	https://api.vietqr.io/img/VIETTELMONEY.png
56	VNPT Money	VNPTMoney	https://api.vietqr.io/img/VNPTMONEY.png
34	Ngân hàng TMCP Sài Gòn Công Thương	SaigonBank	https://api.vietqr.io/img/SGICB.png
3	Ngân hàng TMCP Bắc Á	BacABank	https://api.vietqr.io/img/BAB.png
30	Ngân hàng TMCP Đại Chúng Việt Nam	PVcomBank	https://api.vietqr.io/img/PVCB.png
27	Ngân hàng Thương mại TNHH MTV Đại Dương	Oceanbank	https://api.vietqr.io/img/OCEANBANK.png
24	Ngân hàng TMCP Quốc Dân	NCB	https://api.vietqr.io/img/NCB.png
37	Ngân hàng TNHH MTV Shinhan Việt Nam	ShinhanBank	https://api.vietqr.io/img/SHBVN.png
1	Ngân hàng TMCP An Bình	ABBANK	https://api.vietqr.io/img/ABB.png
41	Ngân hàng TMCP Việt Á	VietABank	https://api.vietqr.io/img/VAB.png
23	Ngân hàng TMCP Nam Á	NamABank	https://api.vietqr.io/img/NAB.png
29	Ngân hàng TMCP Xăng dầu Petrolimex	PGBank	https://api.vietqr.io/img/PGB.png
46	Ngân hàng TMCP Việt Nam Thương Tín	VietBank	https://api.vietqr.io/img/VIETBANK.png
5	Ngân hàng TMCP Bảo Việt	BaoVietBank	https://api.vietqr.io/img/BVB.png
33	Ngân hàng TMCP Đông Nam Á	SeABank	https://api.vietqr.io/img/SEAB.png
52	Ngân hàng Hợp tác xã Việt Nam	COOPBANK	https://api.vietqr.io/img/COOPBANK.png
20	Ngân hàng TMCP Bưu Điện Liên Việt	LienVietPostBank	https://api.vietqr.io/img/LPB.png
19	Ngân hàng TMCP Kiên Long	KienLongBank	https://api.vietqr.io/img/KLB.png
55	Ngân hàng Đại chúng TNHH Kasikornbank	KBank	https://api.vietqr.io/img/KBANK.png
48	Ngân hàng Liên doanh Việt - Nga	VRB	https://api.vietqr.io/img/VRB.png
32	Ngân hàng TNHH MTV Standard Chartered Bank Việt Nam	StandardChartered	https://api.vietqr.io/img/SCVN.png
25	Ngân hàng Nonghyup - Chi nhánh Hà Nội	Nonghyup	https://api.vietqr.io/img/NHB.png
18	Ngân hàng TNHH Indovina	IndovinaBank	https://api.vietqr.io/img/IVB.png
16	Ngân hàng Công nghiệp Hàn Quốc - Chi nhánh TP. Hồ Chí Minh	IBKHCM	https://api.vietqr.io/img/IBK.png
51	Ngân hàng Kookmin - Chi nhánh Thành phố Hồ Chí Minh	KookminHCM	https://api.vietqr.io/img/KBHCM.png
50	Ngân hàng Kookmin - Chi nhánh Hà Nội	KookminHN	https://api.vietqr.io/img/KBHN.png
49	Ngân hàng TNHH MTV Woori Việt Nam	Woori	https://api.vietqr.io/img/WVN.png
14	Ngân hàng TNHH MTV HSBC (Việt Nam)	HSBC	https://api.vietqr.io/img/HSBC.png
6	Ngân hàng Thương mại TNHH MTV Xây dựng Việt Nam	CBBank	https://api.vietqr.io/img/CBB.png
15	Ngân hàng Công nghiệp Hàn Quốc - Chi nhánh Hà Nội	IBKHN	https://api.vietqr.io/img/IBK.png
7	Ngân hàng TNHH MTV CIMB Việt Nam	CIMB	https://api.vietqr.io/img/CIMB.png
8	DBS Bank Ltd - Chi nhánh Thành phố Hồ Chí Minh	DBSBank	https://api.vietqr.io/img/DBS.png
9	Ngân hàng TMCP Đông Á	DongABank	https://api.vietqr.io/img/DOB.png
11	Ngân hàng Thương mại TNHH MTV Dầu Khí Toàn Cầu	GPBank	https://api.vietqr.io/img/GPB.png
28	Ngân hàng TNHH MTV Public Việt Nam	PublicBank	https://api.vietqr.io/img/PBVN.png
40	Ngân hàng United Overseas - Chi nhánh TP. Hồ Chí Minh	UnitedOverseas	https://api.vietqr.io/img/UOB.png
13	Ngân hàng TNHH MTV Hong Leong Việt Nam	HongLeong	https://api.vietqr.io/img/HLBVN.png
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
1	Hồ Chí Minh
2	Hà Nội
3	Đà Nẵng
4	Bình Dương
5	Đồng Nai
6	Khánh Hòa
7	Hải Phòng
8	Long An
9	Quảng Nam
10	Bà Rịa Vũng Tàu
11	Đắk Lắk
12	Cần Thơ
13	Bình Thuận  
14	Lâm Đồng
15	Thừa Thiên Huế
16	Kiên Giang
17	Bắc Ninh
18	Quảng Ninh
19	Thanh Hóa
20	Nghệ An
21	Hải Dương
22	Gia Lai
23	Bình Phước
24	Hưng Yên
25	Bình Định
26	Tiền Giang
27	Thái Bình
28	Bắc Giang
29	Hòa Bình
30	An Giang
31	Vĩnh Phúc
32	Tây Ninh
33	Thái Nguyên
34	Lào Cai
35	Nam Định
36	Quảng Ngãi
37	Bến Tre
38	Đắk Nông
39	Cà Mau
40	Vĩnh Long
41	Ninh Bình
42	Phú Thọ
43	Ninh Thuận
44	Phú Yên
45	Hà Nam
46	Hà Tĩnh
47	Đồng Tháp
48	Sóc Trăng
49	Kon Tum
50	Quảng Bình
51	Quảng Trị
52	Trà Vinh
53	Hậu Giang
54	Sơn La
55	Bạc Liêu
56	Yên Bái
57	Tuyên Quang
58	Điện Biên
59	Lai Châu
60	Lạng Sơn
61	Hà Giang
62	Bắc Kạn
63	Cao Bằng
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
1	Bình Chánh	1
2	Bình Tân	1
3	Bình Thạnh	1
4	Cần Giờ	1
5	Củ Chi	1
6	Gò Vấp	1
7	Hóc Môn	1
8	Nhà Bè	1
9	Phú Nhuận	1
10	Quận 1	1
11	Quận 10	1
12	Quận 11	1
13	Quận 12	1
14	Quận 2	1
15	Quận 3	1
16	Quận 4	1
17	Quận 5	1
18	Quận 6	1
19	Quận 7	1
20	Quận 8	1
21	Quận 9	1
22	Tân Bình	1
23	Tân Phú	1
24	Thủ Đức	1
25	Ba Đình	2
26	Ba Vì	2
27	Bắc Từ Liêm	2
28	Cầu Giấy	2
29	Chương Mỹ	2
30	Đan Phượng	2
31	Đông Anh	2
32	Đống Đa	2
33	Gia Lâm	2
34	Hà Đông	2
35	Hai Bà Trưng	2
36	Hoài Đức	2
37	Hoàn Kiếm	2
38	Hoàng Mai	2
39	Long Biên	2
40	Mê Linh	2
41	Mỹ Đức	2
42	Nam Từ Liêm	2
43	Phú Xuyên	2
44	Phúc Thọ	2
45	Quốc Oai	2
46	Sóc Sơn	2
47	Sơn Tây	2
48	Tây Hồ	2
49	Thạch Thất	2
50	Thanh Oai	2
51	Thanh Trì	2
52	Thanh Xuân	2
53	Thường Tín	2
54	Ứng Hòa	2
55	Cẩm Lệ	3
56	Hải Châu	3
57	Hòa Vang	3
58	Hoàng Sa	3
59	Liên Chiểu	3
60	Ngũ Hành Sơn	3
61	Sơn Trà	3
62	Thanh Khê	3
63	Bàu Bàng	4
64	Bến Cát	4
65	Dầu Tiếng	4
66	Dĩ An	4
67	Phú Giáo	4
68	Tân Uyên	4
69	Thủ Dầu Một	4
70	Thuận An	4
71	Biên Hòa	5
72	Cẩm Mỹ	5
73	Định Quán	5
74	Long Khánh	5
75	Long Thành	5
76	Nhơn Trạch	5
77	Tân Phú	5
78	Thống Nhất	5
79	Trảng Bom	5
80	Vĩnh Cửu	5
81	Xuân Lộc	5
82	Cam Lâm	6
83	Cam Ranh	6
84	Diên Khánh	6
85	Khánh Sơn	6
86	Khánh Vĩnh	6
87	Nha Trang	6
88	Ninh Hòa	6
89	Trường Sa	6
90	Vạn Ninh	6
91	An Dương	7
92	An Lão	7
93	Bạch Long Vĩ	7
94	Cát Hải	7
97	Hải An	7
98	Hồng Bàng	7
99	Kiến An	7
100	Kiến Thụy	7
101	Lê Chân	7
102	Ngô Quyền	7
103	Thủy Nguyên	7
104	Tiên Lãng	7
105	Vĩnh Bảo	7
106	Bến Lức	8
107	Cần Đước	8
108	Cần Giuộc	8
109	Châu Thành	8
110	Đức Hòa	8
111	Đức Huệ	8
112	Kiến Tường	8
113	Mộc Hóa	8
114	Tân An	8
115	Tân Hưng	8
116	Tân Thạnh	8
117	Tân Trụ	8
118	Thạnh Hóa	8
119	Thủ Thừa	8
120	Vĩnh Hưng	8
121	Bắc Trà My	9
126	Hiệp Đức	9
127	Hội An	9
128	Nam Giang	9
129	Nam Trà My	9
130	Nông Sơn	9
131	Núi Thành	9
132	Phú Ninh	9
133	Phước Sơn	9
134	Quế Sơn	9
135	Tam Kỳ	9
136	Tây Giang	9
137	Thăng Bình	9
138	Tiên Phước	9
139	Bà Rịa	10
140	Châu Đức	10
141	Côn Đảo	10
142	Đất Đỏ	10
143	Long Điền	10
144	Tân Thành	10
145	Vũng Tàu	10
146	Xuyên Mộc	10
147	Buôn Đôn	11
148	Buôn Hồ	11
149	Buôn Ma Thuột	11
150	Cư Kuin	11
151	Cư M'gar	11
152	Ea H'Leo	11
153	Ea Kar	11
154	Ea Súp	11
155	Krông Ana	11
156	Krông Bông	11
157	Krông Buk	11
158	Krông Năng	11
159	Krông Pắc	11
160	Lăk	11
161	M'Đrăk	11
162	 Thới Lai	12
163	Bình Thủy	12
164	Cái Răng	12
165	Cờ Đỏ	12
166	Ninh Kiều	12
167	Ô Môn	12
168	Phong Điền	12
169	Thốt Nốt	12
170	Vĩnh Thạnh	12
171	Bắc Bình	13
172	Đảo Phú Quý	13
173	Đức Linh	13
174	Hàm Tân	13
175	Hàm Thuận Bắc	13
176	Hàm Thuận Nam	13
177	La Gi	13
178	Phan Thiết	13
179	Tánh Linh	13
180	Tuy Phong	13
181	Bảo Lâm	14
182	Bảo Lộc	14
183	Cát Tiên	14
189	Đơn Dương	14
190	Đức Trọng	14
191	Lạc Dương	14
192	Lâm Hà	14
193	A Lưới	15
194	Huế	15
195	Hương Thủy	15
196	Hương Trà	15
197	Nam Đông	15
198	Phong Điền	15
199	Phú Lộc	15
200	Phú Vang	15
201	Quảng Điền	15
202	An Biên	16
203	An Minh	16
204	Châu Thành	16
205	Giang Thành	16
206	Giồng Riềng	16
207	Gò Quao	16
208	Hà Tiên	16
209	Hòn Đất	16
210	Kiên Hải	16
211	Kiên Lương	16
212	Phú Quốc	16
213	Rạch Giá	16
214	Tân Hiệp	16
215	U minh Thượng	16
216	Vĩnh Thuận	16
217	Bắc Ninh	17
218	Gia Bình	17
219	Lương Tài	17
220	Quế Võ	17
221	Thuận Thành	17
222	Tiên Du	17
223	Từ Sơn	17
224	Yên Phong	17
225	Ba Chẽ	18
226	Bình Liêu	18
227	Cẩm Phả	18
228	Cô Tô	18
229	Đầm Hà	18
230	Đông Triều	18
231	Hạ Long	18
232	Hải Hà	18
233	Hoành Bồ	18
234	Móng Cái	18
235	Quảng Yên	18
236	Tiên Yên	18
237	Uông Bí	18
238	Vân Đồn	18
239	Bá Thước	19
240	Bỉm Sơn	19
241	Cẩm Thủy	19
242	Đông Sơn	19
243	Hà Trung	19
244	Hậu Lộc	19
245	Hoằng Hóa	19
246	Lang Chánh	19
247	Mường Lát	19
248	Nga Sơn	19
249	Ngọc Lặc	19
250	Như Thanh	19
251	Như Xuân	19
252	Nông Cống	19
253	Quan Hóa	19
254	Quan Sơn	19
255	Quảng Xương	19
256	Sầm Sơn	19
257	Thạch Thành	19
258	Thanh Hóa	19
259	Thiệu Hóa	19
260	Thọ Xuân	19
261	Thường Xuân	19
262	Tĩnh Gia	19
263	Triệu Sơn	19
264	Vĩnh Lộc	19
265	Yên Định	19
266	Anh Sơn	20
267	Con Cuông	20
268	Cửa Lò	20
269	Diễn Châu	20
270	Đô Lương	20
271	Hoàng Mai	20
272	Hưng Nguyên	20
273	Kỳ Sơn	20
274	Nam Đàn	20
275	Nghi Lộc	20
276	Nghĩa Đàn	20
277	Quế Phong	20
278	Quỳ Châu	20
279	Quỳ Hợp	20
280	Quỳnh Lưu	20
281	Tân Kỳ	20
282	Thái Hòa	20
283	Thanh Chương	20
284	Tương Dương	20
285	Vinh	20
286	Yên Thành	20
287	Bình Giang	21
288	Cẩm Giàng	21
289	Chí Linh	21
290	Gia Lộc	21
291	Hải Dương	21
292	Kim Thành	21
293	Kinh Môn	21
294	Nam Sách	21
295	Ninh Giang	21
296	Thanh Hà	21
297	Thanh Miện	21
298	Tứ Kỳ	21
299	An Khê	22
300	AYun Pa	22
301	Chư Păh	22
302	Chư Pưh	22
303	Chư Sê	22
304	ChưPRông	22
305	Đăk Đoa	22
306	Đăk Pơ	22
307	Đức Cơ	22
308	Ia Grai	22
309	Ia Pa	22
310	KBang	22
311	Kông Chro	22
312	Krông Pa	22
313	Mang Yang	22
314	Phú Thiện	22
315	Plei Ku	22
316	Bình Long	23
317	Bù Đăng	23
318	Bù Đốp	23
319	Bù Gia Mập	23
320	Chơn Thành	23
321	Đồng Phú	23
322	Đồng Xoài	23
323	Hớn Quản	23
324	Lộc Ninh	23
325	Phú Riềng	23
326	Phước Long	23
327	Ân Thi	24
328	Hưng Yên	24
329	Khoái Châu	24
330	Kim Động	24
331	Mỹ Hào	24
332	Phù Cừ	24
333	Tiên Lữ	24
334	Văn Giang	24
335	Văn Lâm	24
336	Yên Mỹ	24
337	An Lão	25
338	An Nhơn	25
339	Hoài Ân	25
340	Hoài Nhơn	25
341	Phù Cát	25
342	Phù Mỹ	25
343	Quy Nhơn	25
344	Tây Sơn	25
345	Tuy Phước	25
346	Vân Canh	25
347	Vĩnh Thạnh	25
348	Cái Bè	26
349	Cai Lậy	26
350	Châu Thành	26
351	Chợ Gạo	26
352	Gò Công	26
353	Gò Công Đông	26
354	Gò Công Tây	26
355	Huyện Cai Lậy	26
356	Mỹ Tho	26
357	Tân Phú Đông	26
358	Tân Phước	26
359	Đông Hưng	27
360	Hưng Hà	27
361	Kiến Xương	27
362	Quỳnh Phụ	27
363	Thái Bình	27
364	Thái Thuỵ	27
365	Tiền Hải	27
366	Vũ Thư	27
367	Bắc Giang	28
368	Hiệp Hòa	28
369	Lạng Giang	28
370	Lục Nam	28
371	Lục Ngạn	28
372	Sơn Động	28
373	Tân Yên	28
374	Việt Yên	28
375	Yên Dũng	28
376	Yên Thế	28
377	Cao Phong	29
378	Đà Bắc	29
379	Hòa Bình	29
380	Kim Bôi	29
381	Kỳ Sơn	29
382	Lạc Sơn	29
383	Lạc Thủy	29
384	Lương Sơn	29
385	Mai Châu	29
386	Tân Lạc	29
387	Yên Thủy	29
388	An Phú	30
389	Châu Đốc	30
390	Châu Phú	30
391	Châu Thành	30
392	Chợ Mới	30
393	Long Xuyên	30
394	Phú Tân	30
395	Tân Châu	30
396	Thoại Sơn	30
397	Tịnh Biên	30
398	Tri Tôn	30
399	Bình Xuyên	31
400	Lập Thạch	31
401	Phúc Yên	31
402	Sông Lô	31
405	Vĩnh Tường	31
406	Vĩnh Yên	31
407	Yên Lạc	31
408	Bến Cầu	32
409	Châu Thành	32
410	Dương Minh Châu	32
411	Gò Dầu	32
412	Hòa Thành	32
413	Tân Biên	32
414	Tân Châu	32
415	Tây Ninh	32
416	Trảng Bàng	32
417	Đại Từ	33
418	Định Hóa	33
419	Đồng Hỷ	33
420	Phổ Yên	33
421	Phú Bình	33
422	Phú Lương	33
423	Sông Công	33
424	Thái Nguyên	33
425	Võ Nhai	33
426	Bắc Hà	34
427	Bảo Thắng	34
428	Bảo Yên	34
429	Bát Xát	34
430	Lào Cai	34
431	Mường Khương	34
432	Sa Pa	34
433	Văn Bàn	34
434	Xi Ma Cai	34
435	Giao Thủy	35
436	Hải Hậu	35
437	Mỹ Lộc	35
438	Nam Định	35
439	Nam Trực	35
440	Nghĩa Hưng	35
441	Trực Ninh	35
442	Vụ Bản	35
443	Xuân Trường	35
444	Ý Yên	35
445	Ba Tơ	36
446	Bình Sơn	36
447	Đức Phổ	36
448	Lý Sơn	36
449	Minh Long	36
450	Mộ Đức	36
451	Nghĩa Hành	36
452	Quảng Ngãi	36
453	Sơn Hà	36
454	Sơn Tây	36
455	Sơn Tịnh	36
456	Tây Trà	36
457	Trà Bồng	36
458	Tư Nghĩa	36
459	Ba Tri	37
460	Bến Tre	37
461	Bình Đại	37
462	Châu Thành	37
463	Chợ Lách	37
464	Giồng Trôm	37
465	Mỏ Cày Bắc	37
466	Mỏ Cày Nam	37
467	Thạnh Phú	37
468	Cư Jút	38
469	Dăk GLong	38
470	Dăk Mil	38
471	Dăk R'Lấp	38
472	Dăk Song	38
473	Gia Nghĩa	38
474	Krông Nô	38
475	Tuy Đức	38
476	Cà Mau	39
477	Cái Nước	39
478	Đầm Dơi	39
479	Năm Căn	39
480	Ngọc Hiển	39
481	Phú Tân	39
482	Thới Bình	39
483	Trần Văn Thời	39
484	U Minh	39
485	Bình Minh	40
486	Bình Tân	40
487	Long Hồ	40
488	Mang Thít	40
489	Tam Bình	40
490	Trà Ôn	40
491	Vĩnh Long	40
492	Vũng Liêm	40
493	Gia Viễn	41
494	Hoa Lư	41
495	Kim Sơn	41
496	Nho Quan	41
497	Ninh Bình	41
498	Tam Điệp	41
499	Yên Khánh	41
500	Yên Mô	41
501	Cẩm Khê	42
502	Đoan Hùng	42
503	Hạ Hòa	42
504	Lâm Thao	42
505	Phù Ninh	42
506	Phú Thọ	42
507	Tam Nông	42
508	Tân Sơn	42
509	Thanh Ba	42
510	Thanh Sơn	42
511	Thanh Thủy	42
512	Việt Trì	42
513	Yên Lập	42
514	Bác Ái	43
515	Ninh Hải	43
516	Ninh Phước	43
517	Ninh Sơn	43
518	Phan Rang - Tháp Chàm	43
519	Thuận Bắc	43
520	Thuận Nam	43
521	Đông Hòa	44
522	Đồng Xuân	44
523	Phú Hòa	44
524	Sơn Hòa	44
525	Sông Cầu	44
526	Sông Hinh	44
527	Tây Hòa	44
528	Tuy An	44
529	Tuy Hòa	44
530	Bình Lục	45
531	Duy Tiên	45
532	Kim Bảng	45
533	Lý Nhân	45
534	Phủ Lý	45
535	Thanh Liêm	45
536	Cẩm Xuyên	46
537	Can Lộc	46
538	Đức Thọ	46
539	Hà Tĩnh	46
540	Hồng Lĩnh	46
541	Hương Khê	46
542	Hương Sơn	46
543	Kỳ Anh	46
544	Lộc Hà	46
545	Nghi Xuân	46
546	Thạch Hà	46
547	Vũ Quang	46
548	Cao Lãnh	47
549	Châu Thành	47
550	Hồng Ngự	47
551	Huyện Cao Lãnh	47
552	Huyện Hồng Ngự	47
553	Lai Vung	47
554	Lấp Vò	47
555	Sa Đéc	47
556	Tam Nông	47
557	Tân Hồng	47
558	Thanh Bình	47
559	Tháp Mười	47
560	Châu Thành	48
561	Cù Lao Dung	48
562	Kế Sách	48
563	Long Phú	48
564	Mỹ Tú	48
565	Mỹ Xuyên	48
566	Ngã Năm	48
567	Sóc Trăng	48
568	Thạnh Trị	48
569	Trần Đề	48
570	Vĩnh Châu	48
571	Đăk Glei	49
572	Đăk Hà	49
573	Đăk Tô	49
574	Ia H'Drai	49
575	Kon Plông	49
576	Kon Rẫy	49
577	KonTum	49
578	Ngọc Hồi	49
579	Sa Thầy	49
580	Tu Mơ Rông	49
581	Ba Đồn	50
582	Bố Trạch	50
583	Đồng Hới	50
584	Lệ Thủy	50
585	Minh Hóa	50
586	Quảng Ninh	50
587	Quảng Trạch	50
588	Tuyên Hóa	50
589	Cam Lộ	51
590	Đa Krông	51
591	Đảo Cồn cỏ	51
592	Đông Hà	51
593	Gio Linh	51
594	Hải Lăng	51
595	Hướng Hóa	51
596	Quảng Trị	51
597	Triệu Phong	51
598	Vĩnh Linh	51
599	Càng Long	52
600	Cầu Kè	52
601	Cầu Ngang	52
602	Châu Thành	52
603	Duyên Hải	52
604	Tiểu Cần	52
605	Trà Cú	52
606	Trà Vinh	52
607	Châu Thành	53
608	Châu Thành A	53
609	Long Mỹ	53
610	Ngã Bảy	53
611	Phụng Hiệp	53
612	Vị Thanh	53
613	Vị Thủy	53
614	Bắc Yên	54
615	Mai Sơn	54
616	Mộc Châu	54
617	Mường La	54
618	Phù Yên	54
619	Quỳnh Nhai	54
620	Sơn La	54
621	Sông Mã	54
622	Sốp Cộp	54
623	Thuận Châu	54
624	Vân Hồ	54
625	Yên Châu	54
626	Bạc Liêu	55
627	Đông Hải	55
628	Giá Rai	55
629	Hòa Bình	55
630	Hồng Dân	55
631	Phước Long	55
632	Vĩnh Lợi	55
633	Lục Yên	56
634	Mù Cang Chải	56
635	Nghĩa Lộ	56
636	Trạm Tấu	56
637	Trấn Yên	56
638	Văn Chấn	56
639	Văn Yên	56
640	Yên Bái	56
641	Yên Bình	56
642	Chiêm Hóa	57
643	Hàm Yên	57
644	Lâm Bình	57
645	Na Hang	57
646	Sơn Dương	57
647	Tuyên Quang	57
648	Yên Sơn	57
649	Điện Biên	58
650	Điện Biên Đông	58
651	Điện Biên Phủ	58
652	Mường Ảng	58
653	Mường Chà	58
654	Mường Lay	58
655	Mường Nhé	58
656	Nậm Pồ	58
657	Tủa Chùa	58
658	Tuần Giáo	58
659	Lai Châu	59
660	Mường Tè	59
661	Nậm Nhùn	59
662	Phong Thổ	59
663	Sìn Hồ	59
664	Tam Đường	59
665	Tân Uyên	59
666	Than Uyên	59
667	Bắc Sơn	60
668	Bình Gia	60
669	Cao Lộc	60
670	Chi Lăng	60
671	Đình Lập	60
672	Hữu Lũng	60
673	Lạng Sơn	60
674	Lộc Bình	60
675	Tràng Định	60
676	Văn Lãng	60
677	Văn Quan	60
678	Bắc Mê	61
679	Bắc Quang	61
680	Đồng Văn	61
681	Hà Giang	61
682	Hoàng Su Phì	61
683	Mèo Vạc	61
684	Quản Bạ	61
685	Quang Bình	61
686	Vị Xuyên	61
687	Xín Mần	61
688	Yên Minh	61
689	Ba Bể	62
690	Bắc Kạn	62
691	Bạch Thông	62
692	Chợ Đồn	62
693	Chợ Mới	62
694	Na Rì	62
695	Ngân Sơn	62
696	Pác Nặm	62
697	Bảo Lạc	63
698	Bảo Lâm	63
699	Cao Bằng	63
700	Hạ Lang	63
701	Hà Quảng	63
702	Hòa An	63
703	Nguyên Bình	63
704	Phục Hòa	63
705	Quảng Uyên	63
706	Thạch An	63
707	Thông Nông	63
708	Trà Lĩnh	63
709	Trùng Khánh	63
96	Dương Kinh	7
95	Đồ Sơn	7
125	Duy Xuyên	9
122	Đại Lộc	9
123	Điện Bàn	9
124	Đông Giang	9
188	Di Linh	14
184	Đạ Huoai	14
185	Đà Lạt	14
186	Đạ Tẻh	14
187	Đam Rông	14
404	Tam Dương	31
403	Tam Đảo	31
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
2	NĐT	0	0	0
3	Chuyên viên	5	1	0
4	Quản lý	6	5	20
5	Trưởng phòng	4	3	0
6	Phó giám đốc	4	5	0
7	Giám đốc	5	0	0
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
Xem danh sách NFT địa điểm	LOCATION	1	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Sửa, xóa, thêm mới danh sách NFT địa điểm	LOCATION	2	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duyệt NFT địa điểm	LOCATION	24	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem giá NFT	PRICE_LOCATION	3	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Sửa, xóa giá NFT	PRICE_LOCATION	4	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem Đơn mua combo	COMBO	5	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Sửa, xóa, thêm mới Đơn mua combo	COMBO	6	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem tài khoản ADMIN	ADMIN	7	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Sửa, xóa, thêm mới tài khoản ADMIN	ADMIN	8	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duyệt tài khoản ADMIN	ADMIN	9	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem nhóm phân quyền	ROLE	10	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Sửa, xóa, thêm mới nhóm phân quyền	ROLE	11	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duyệt nhóm phân quyền	ROLE	12	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem khách hàng	CUSTOMER	13	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Sửa, xóa, thêm mới khách hàng	CUSTOMER	14	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duyệt khách hàng	CUSTOMER	15	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem KYC	KYC	16	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Duyệt KYC	KYC	17	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem giao dịch tiền & LOCA	LOCA	18	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Sửa, xóa, thêm mới giao dịch tiền & LOCA	LOCA	19	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem thông báo MAIL/SMS	NOTIFY	20	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Sửa, xóa, thêm thông báo MAIL/SMS	NOTIFY	21	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Xem cấu hình hệ thống	SYSTEM	22	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
Sửa, xóa, thêm cấu hình hệ thống 	SYSTEM	23	2022-11-30 14:47:57.768223	2022-11-30 14:47:57.768223
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