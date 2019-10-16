# Architectural Decision Log

This log lists the architectural decisions for Digitale Dagpenger.

<!-- adrlog -- Regenerate the content by using "adr-log -i". You can install it via "npm install -g adr-log" -->

- [ADR-0000](0000-adopt-architecture-decision-records.md) - Adopt Architecture Decision Records
- [ADR-0001](0001-be-transparent.md) - Be transparent
- [ADR-0002](0002-use-norwegian-for-domain-concepts.md) - Use Norwegian for Domain Specific Concepts
- [ADR-0003](0003-use-markdown-architectural-decision-records.md) - Use Markdown Architectural Decision Records
- [ADR-0004](0004-Partisjonsnøkkel-for-dagpenger-behov-kafka-topic.md) - Partisjonsnøkkel for 'Dagpenger Behov'  Kafka-topic
- [ADR-0005](0005-bruk-ULID-for-id-generering.md) - Bruk ULID (Universally Unique Lexicographically Sortable Identifier) som ID-generingsmekanisme
- [ADR-0006](0006-bruk-ren-json-for-regelbehov.md) - Bruk 'ren' json for regelbehov over avro eller serialisering/deserialisering til dataklasser
- [ADR-0007](0007-bruk-rfc7807-http-problem-detail-for-feilbeskrivelse.md) - Bruk rfc7807 "http problem detail" spesifikasjon til å lage strukturelle feilbeskrivelser i HTTP APIer og KAFKA meldinger
- [ADR-0008](0008-kommunikasjon-mellom-sbs-og-regel-api.md) - Bruk sonekryssing for å løse kommunikasjon mellom appene
- [ADR-0009](0009-sonekryssing-dagpenger.md) - Bruk helse-reverse-proxy som basis for sonekryssingen

<!-- adrlogstop -->

For new ADRs, please use [template.md](template.md) as basis.
More information on MADR is available at <https://adr.github.io/madr/>.
General information about architectural decision records is available at <https://adr.github.io/>.
