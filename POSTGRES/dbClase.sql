--
-- PostgreSQL database dump
--

-- Dumped from database version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.7 (Ubuntu 14.7-0ubuntu0.22.04.1)

-- Started on 2023-05-23 11:09:15 CEST

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 209 (class 1259 OID 16392)
-- Name: enunciado; Type: TABLE; Schema: public; Owner: usuario
--

CREATE TABLE public.enunciado (
    codenunciado integer NOT NULL,
    texto text
);


ALTER TABLE public.enunciado OWNER TO usuario;

--
-- TOC entry 211 (class 1259 OID 16410)
-- Name: frases; Type: TABLE; Schema: public; Owner: usuario
--

CREATE TABLE public.frases (
    codfrase integer NOT NULL,
    observaciones text
)
INHERITS (public.enunciado);


ALTER TABLE public.frases OWNER TO usuario;

--
-- TOC entry 210 (class 1259 OID 16405)
-- Name: oraciones; Type: TABLE; Schema: public; Owner: usuario
--

CREATE TABLE public.oraciones (
    codoracion integer,
    verbo character varying(20)
)
INHERITS (public.enunciado);


ALTER TABLE public.oraciones OWNER TO usuario;

--
-- TOC entry 3400 (class 0 OID 16392)
-- Dependencies: 209
-- Data for Name: enunciado; Type: TABLE DATA; Schema: public; Owner: usuario
--

COPY public.enunciado (codenunciado, texto) FROM stdin;
\.


--
-- TOC entry 3402 (class 0 OID 16410)
-- Dependencies: 211
-- Data for Name: frases; Type: TABLE DATA; Schema: public; Owner: usuario
--

COPY public.frases (codenunciado, texto, codfrase, observaciones) FROM stdin;
1	prueba 1	1	Nada que declarar
2	prueba 1	2	Nada que declarar
\.


--
-- TOC entry 3401 (class 0 OID 16405)
-- Dependencies: 210
-- Data for Name: oraciones; Type: TABLE DATA; Schema: public; Owner: usuario
--

COPY public.oraciones (codenunciado, texto, codoracion, verbo) FROM stdin;
1	prueba 1	1	Nada que declarar
2	prueba 1	2	Nada que declarar
\.


--
-- TOC entry 3255 (class 2606 OID 16404)
-- Name: enunciado enunciado_pkey; Type: CONSTRAINT; Schema: public; Owner: usuario
--

ALTER TABLE ONLY public.enunciado
    ADD CONSTRAINT enunciado_pkey PRIMARY KEY (codenunciado);


--
-- TOC entry 3257 (class 2606 OID 16416)
-- Name: frases frases_pkey; Type: CONSTRAINT; Schema: public; Owner: usuario
--

ALTER TABLE ONLY public.frases
    ADD CONSTRAINT frases_pkey PRIMARY KEY (codfrase);


--
-- TOC entry 3397 (class 2618 OID 16417)
-- Name: frases controlHerenciaFrases; Type: RULE; Schema: public; Owner: usuario
--

CREATE RULE "controlHerenciaFrases" AS
    ON INSERT TO public.frases
   WHERE (EXISTS ( SELECT frases.codenunciado,
            frases.texto,
            frases.codfrase,
            frases.observaciones
           FROM public.frases
          WHERE (frases.codenunciado = new.codenunciado))) DO INSTEAD NOTHING;


--
-- TOC entry 3398 (class 2618 OID 16418)
-- Name: oraciones controlHerenciaOraciones; Type: RULE; Schema: public; Owner: usuario
--

CREATE RULE "controlHerenciaOraciones" AS
    ON INSERT TO public.oraciones
   WHERE (EXISTS ( SELECT oraciones.codenunciado,
            oraciones.texto,
            oraciones.codoracion,
            oraciones.verbo
           FROM public.oraciones
          WHERE (oraciones.codenunciado = new.codenunciado))) DO INSTEAD NOTHING;


--
-- TOC entry 3399 (class 2618 OID 16419)
-- Name: enunciado controlInsercion; Type: RULE; Schema: public; Owner: usuario
--

CREATE RULE "controlInsercion" AS
    ON INSERT TO public.enunciado DO INSTEAD NOTHING;


-- Completed on 2023-05-23 11:09:15 CEST

--
-- PostgreSQL database dump complete
--

