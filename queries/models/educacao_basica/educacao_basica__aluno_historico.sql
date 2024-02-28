{{ config(alias='aluno_historico', schema='educacao_basica') }}

{{
    config(
        materialized='incremental',
        partition_by={
            "field": "data_particao",
            "data_type": "date",
            "granularity": "year",
        }
    )
}}

SELECT
    SAFE_CAST(ano AS INT64) ano,
    SUBSTR(SHA256(
        CONCAT(
            '{{ var("hash_seed") }}',
            SAFE_CAST(REGEXP_REPLACE(alu_id, r'\.0$', '')  AS STRING)
        )
    ), 2,17) as  id_aluno,
    SUBSTR(SHA256(
        CONCAT(
            '{{ var("hash_seed") }}',
            SAFE_CAST(REGEXP_REPLACE(alu_id, r'\.0$', '')  AS STRING),
            SAFE_CAST(ano AS STRING)
        )
    ), 2,17) as  id_aluno_ano,
    SAFE_CAST(matricula AS STRING) matricula,
    -- SAFE_CAST(nome AS STRING) nome,
    SAFE_CAST(sexo AS STRING) genero,
    SAFE_CAST(naturalidade AS STRING) naturalidade,
    SAFE_CAST(nacionalidade AS STRING) nacionalidade,
    -- SAFE_CAST(endereco AS STRING) endereco,
    -- SAFE_CAST(cep AS STRING) cep,
    -- SAFE_CAST(filiacao_1 AS STRING) filiacao_1,
    SAFE_CAST(filiacao_1_profissao AS STRING) filiacao_1_profissao,
    SAFE_CAST(filiacao_1_escolaridade AS STRING) filiacao_1_escolaridade,
    -- SAFE_CAST(filiacao_2 AS STRING) filiacao_2,
    SAFE_CAST(filiacao_2_profissao AS STRING) filiacao_2_profissao,
    SAFE_CAST(filiacao_2_escolaridade AS STRING) filiacao_2_escolaridade,
    -- SAFE_CAST(cpf AS STRING) cpf,
    -- SAFE_CAST(nis_aluno AS STRING) nis_aluno,
    -- SAFE_CAST(nis_resp AS STRING) nis_resp,
    SAFE_CAST(raca_cor AS STRING) raca_cor,
    SAFE_CAST(REGEXP_REPLACE(cod_def, r'\.0$', '') AS STRING) id_deficiencia,
    SAFE_CAST(tipo_transporte AS STRING) tipo_transporte,
    SAFE_CAST(tempo_deslocamento AS FLOAT64) tempo_deslocamento,
    SAFE_CAST(regressa_sozinho AS STRING) regressa_sozinho,
    SAFE_CAST(religiao AS STRING) religiao,
    SAFE_CAST(cfc AS STRING) cfc,
    SAFE_CAST(territorios_sociais AS STRING) territorios_sociais,
    SAFE_CAST(clube_escolar AS STRING) clube_escolar,
    SAFE_CAST(nucleo_artes AS STRING) nucleo_artes,
    SAFE_CAST(mais_educacao AS STRING) mais_educacao,
    SAFE_CAST(SAFE.PARSE_TIMESTAMP('%d/%m/%Y', datanascimento) AS date) AS data_nascimento,
    SAFE_CAST(REGEXP_REPLACE(idade_atual, r'\.0$', '') AS INT64) idade_atual,
    SAFE_CAST(REGEXP_REPLACE(idade_3112, r'\.0$', '') AS INT64) idade_3112,
    SAFE_CAST(situacao AS STRING) situacao,
    SAFE_CAST(REGEXP_REPLACE(cod_ult_mov, r'\.0$', '') AS STRING) id_ultima_movimentacao,
    SAFE_CAST(ult_movimentacao AS STRING) ultima_movimentacao,
    SAFE_CAST(tot_aluno AS STRING) total_aluno,
    SAFE_CAST(deficiencia AS STRING) deficiencia,
    SAFE_CAST(data_particao AS DATE) data_particao,
FROM `rj-sme.educacao_basica_staging.aluno_historico`
WHERE data_particao < CURRENT_DATE('America/Sao_Paulo')

{% if is_incremental() %}

{% set max_partition = run_query("SELECT gr FROM (SELECT IF(max(data_particao) > CURRENT_DATE('America/Sao_Paulo'), CURRENT_DATE('America/Sao_Paulo'), max(data_particao)) as gr FROM " ~ this ~ ")").columns[0].values()[0] %}

AND
    data_particao > ("{{ max_partition }}")

{% endif %}