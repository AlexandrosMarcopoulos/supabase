-- liquibase formatted sql

-- changeset codex:0001
CREATE TABLE IF NOT EXISTS public.skills (
    id bigserial PRIMARY KEY,
    name text NOT NULL UNIQUE,
    category text,
    difficulty text CHECK (difficulty IN ('beginner', 'intermediate', 'advanced')),
    created_at timestamptz NOT NULL DEFAULT now()
);

COMMENT ON TABLE public.skills IS 'Stores the BrightSkills catalog managed via Liquibase.';

-- rollback DROP TABLE IF EXISTS public.skills;
