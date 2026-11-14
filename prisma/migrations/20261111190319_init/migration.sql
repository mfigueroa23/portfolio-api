-- CreateEnum
CREATE TYPE "content_status" AS ENUM ('draft', 'published');

-- CreateEnum
CREATE TYPE "testimonial_status" AS ENUM ('pending', 'approved');

-- CreateTable
CREATE TABLE "property" (
    "key" VARCHAR(100) NOT NULL,
    "value" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "property_pkey" PRIMARY KEY ("key")
);

-- CreateTable
CREATE TABLE "rate_limit_hit" (
    "id" BIGSERIAL NOT NULL,
    "bucket" VARCHAR(32) NOT NULL,
    "ip" VARCHAR(64) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "rate_limit_hit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "experience" (
    "id" SERIAL NOT NULL,
    "period" VARCHAR(100) NOT NULL,
    "period_es" VARCHAR(100),
    "role" VARCHAR(200) NOT NULL,
    "role_es" VARCHAR(200),
    "company" VARCHAR(200) NOT NULL,
    "description" TEXT NOT NULL,
    "description_es" TEXT,
    "technologies" TEXT[],
    "current" BOOLEAN NOT NULL DEFAULT false,
    "body" TEXT,
    "body_es" TEXT,
    "start_date" DATE,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "experience_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "project" (
    "id" SERIAL NOT NULL,
    "slug" VARCHAR(100) NOT NULL,
    "slug_es" VARCHAR(100),
    "title" VARCHAR(200) NOT NULL,
    "title_es" VARCHAR(200),
    "description" TEXT,
    "description_es" TEXT,
    "image" VARCHAR(500),
    "tags" TEXT[],
    "link" VARCHAR(500),
    "github" VARCHAR(500),
    "body" TEXT,
    "body_es" TEXT,
    "status" "content_status" NOT NULL DEFAULT 'draft',
    "published_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "project_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "certification" (
    "id" SERIAL NOT NULL,
    "position" INTEGER NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "name_es" VARCHAR(200),
    "issuer" VARCHAR(200) NOT NULL,
    "issue_date" DATE NOT NULL,
    "expiry_date" DATE,
    "credential_id" VARCHAR(100),
    "verification_url" VARCHAR(500),
    "file_url" VARCHAR(500),
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "certification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "post" (
    "id" SERIAL NOT NULL,
    "slug" VARCHAR(100) NOT NULL,
    "slug_es" VARCHAR(100),
    "title" VARCHAR(200) NOT NULL,
    "title_es" VARCHAR(200),
    "summary" VARCHAR(300),
    "summary_es" VARCHAR(300),
    "cover_url" VARCHAR(500),
    "tags" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "tag_keys" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "body" TEXT,
    "body_es" TEXT,
    "references" JSONB NOT NULL DEFAULT '[]',
    "status" "content_status" NOT NULL DEFAULT 'draft',
    "published_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "post_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "file" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" VARCHAR(200) NOT NULL,
    "mime" VARCHAR(50) NOT NULL,
    "size" INTEGER NOT NULL,
    "data" BYTEA NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "file_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "resume" (
    "lang" VARCHAR(2) NOT NULL,
    "file_id" UUID NOT NULL,
    "assigned_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "resume_pkey" PRIMARY KEY ("lang")
);

-- CreateTable
CREATE TABLE "testimonial" (
    "id" SERIAL NOT NULL,
    "position" INTEGER,
    "quote" TEXT,
    "quote_es" TEXT,
    "author" VARCHAR(200) NOT NULL,
    "role" VARCHAR(200),
    "role_es" VARCHAR(200),
    "avatar" VARCHAR(500),
    "status" "testimonial_status" NOT NULL DEFAULT 'approved',
    "email" VARCHAR(200),
    "language" VARCHAR(2),
    "notified" BOOLEAN NOT NULL DEFAULT true,
    "submitted_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "testimonial_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "highlight" (
    "id" SERIAL NOT NULL,
    "position" INTEGER NOT NULL,
    "icon" VARCHAR(100) NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "title_es" VARCHAR(200),
    "description" TEXT NOT NULL,
    "description_es" TEXT,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "highlight_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "social_link" (
    "id" SERIAL NOT NULL,
    "position" INTEGER NOT NULL,
    "icon" VARCHAR(100) NOT NULL,
    "href" VARCHAR(500) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "social_link_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "technology" (
    "id" SERIAL NOT NULL,
    "position" INTEGER NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "technology_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "contact_info" (
    "id" SERIAL NOT NULL,
    "position" INTEGER NOT NULL,
    "icon" VARCHAR(100) NOT NULL,
    "label" VARCHAR(100) NOT NULL,
    "label_es" VARCHAR(100),
    "value" VARCHAR(200) NOT NULL,
    "href" VARCHAR(500) NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "contact_info_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cors_origin" (
    "id" SERIAL NOT NULL,
    "origin" VARCHAR(200) NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cors_origin_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "rate_limit_hit_bucket_ip_created_at_idx" ON "rate_limit_hit"("bucket", "ip", "created_at");

-- CreateIndex
CREATE INDEX "experience_current_start_date_id_idx" ON "experience"("current" DESC, "start_date" DESC, "id");

-- CreateIndex
CREATE UNIQUE INDEX "project_slug_key" ON "project"("slug");

-- CreateIndex
CREATE INDEX "project_status_published_at_idx" ON "project"("status", "published_at" DESC);

-- CreateIndex
CREATE INDEX "certification_position_idx" ON "certification"("position");

-- CreateIndex
CREATE UNIQUE INDEX "post_slug_key" ON "post"("slug");

-- CreateIndex
CREATE INDEX "post_status_published_at_idx" ON "post"("status", "published_at" DESC);

-- CreateIndex
CREATE INDEX "post_tag_keys_idx" ON "post" USING GIN ("tag_keys");

-- CreateIndex
CREATE INDEX "file_created_at_idx" ON "file"("created_at" DESC);

-- CreateIndex
CREATE INDEX "resume_file_id_idx" ON "resume"("file_id");

-- CreateIndex
CREATE INDEX "testimonial_status_position_idx" ON "testimonial"("status", "position");

-- CreateIndex
CREATE INDEX "testimonial_status_submitted_at_idx" ON "testimonial"("status", "submitted_at" DESC);

-- CreateIndex
CREATE INDEX "highlight_position_idx" ON "highlight"("position");

-- CreateIndex
CREATE INDEX "social_link_position_idx" ON "social_link"("position");

-- CreateIndex
CREATE INDEX "technology_position_idx" ON "technology"("position");

-- CreateIndex
CREATE INDEX "contact_info_position_idx" ON "contact_info"("position");

-- CreateIndex
CREATE UNIQUE INDEX "cors_origin_origin_key" ON "cors_origin"("origin");

-- AddForeignKey
ALTER TABLE "resume" ADD CONSTRAINT "resume_file_id_fkey" FOREIGN KEY ("file_id") REFERENCES "file"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
