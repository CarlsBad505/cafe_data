SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: street_cafes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.street_cafes (
    id bigint NOT NULL,
    name character varying,
    address character varying,
    postal_code character varying,
    chairs integer,
    category character varying
);


--
-- Name: category_views; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.category_views AS
 SELECT sc.category,
    count(sc.category) AS total_places,
    sum(sc.chairs) AS total_chairs
   FROM public.street_cafes sc
  GROUP BY sc.category
  ORDER BY sc.category;


--
-- Name: postal_code_views; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.postal_code_views AS
 SELECT sc.postal_code,
    count(sc.postal_code) AS total_places,
    sum(sc.chairs) AS total_chairs,
    round(((100)::numeric * ((sum(sc.chairs))::numeric / sum(sum(sc.chairs)) OVER ())), 2) AS chairs_pct,
    ( SELECT street_cafes.name
           FROM public.street_cafes
          WHERE (street_cafes.chairs = max(sc.chairs))
         LIMIT 1) AS place_with_max_chairs,
    max(sc.chairs) AS max_chairs
   FROM public.street_cafes sc
  GROUP BY sc.postal_code
  ORDER BY sc.postal_code;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: street_cafes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.street_cafes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: street_cafes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.street_cafes_id_seq OWNED BY public.street_cafes.id;


--
-- Name: street_cafes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.street_cafes ALTER COLUMN id SET DEFAULT nextval('public.street_cafes_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: street_cafes street_cafes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.street_cafes
    ADD CONSTRAINT street_cafes_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181211184302'),
('20181212005022'),
('20181213162131'),
('20181214170028');


