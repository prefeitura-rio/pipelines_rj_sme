SELECT
    SAFE_CAST(taa_frequencia AS INT64) AS faltas_disciplina_dia,
    SAFE_CAST(taa_situacao AS INT64) AS situacao,
    SAFE_CAST(taa_dataCriacao AS DATETIME) AS data_criacao,
    SAFE_CAST(taa_dataAlteracao AS DATETIME) AS data_alteracao,
    SAFE_CAST(taa_anotacao AS STRING) AS anotacao,
    SAFE_CAST(taa_frequenciaBitMap AS STRING) AS frequencia_tempo,
    SAFE_CAST(usu_idDocenteAlteracao AS STRING) AS usuario_alteracao,
    SAFE_CAST(mtd_id AS STRING) AS id_matricula_disciplina,
    SAFE_CAST(tau_id AS STRING) AS id_aula_disciplina,
    SAFE_CAST(tud_id AS STRING) AS id_disciplina_turma,
    SAFE_CAST(mtu_id AS STRING) AS id_matricula_turma,
    SAFE_CAST(alu_id AS STRING) AS id_aluno
FROM `rj-sme.educacao_basica_frequencia_staging.turma_aula_aluno`