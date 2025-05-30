{{ config(
    alias='carga_aluno_frequencia'
) }}

with frqtrn as (
    select
        trn_id,
        count(*) / 5 as temposDia
    from {{ ref('brutos_gestao_escolar__turno_horario') }}
    where trh_situacao = 1
    group by trn_id
),

diasCoc as (
    select distinct
        cal.cal_id,
        tpc_id,
        dbo.FN_CalcularDiasUteis(
            cap_dataInicio,
            cap_dataFim,
            '8BB1DECA-BB19-E011-87E8-E61F133BFC53',
            cal.cal_id
        ) as diasCoc
    from {{ ref('brutos_gestao_escolar__calendario_periodo') }} cap
    inner join {{ ref('brutos_gestao_escolar__calendario_anual') }} cal
        on cal.cal_id = cap.cal_id
        and cal_situacao <> 3
    inner join {{ ref('brutos_gestao_escolar__processo_fechamento_inicio') }} pfi
        on pfi.pfi_anoInicio = cal.cal_ano
        and pfi_situacao <> 3
        and pfi_AnoLetivoCorrente = TRUE
), frqbase as (

    select
        alu_id,
        tpc_id,
        count(*) as registros,

        case when tpc_id = '1' then round(sum(freq_COC_1)/count(*), 2) else 0 end as freq_COC_1,
        case when tpc_id = '1' then sum(faltas_coc_1)/count(*) else 0 end as faltas_coc_1,
        case when tpc_id = '1' then sum(numeroAulas_coc_1)/count(*) else 0 end as numeroAulas_coc_1,

        case when tpc_id = '2' then round(sum(freq_COC_2)/count(*), 2) else 0 end as freq_COC_2,
        case when tpc_id = '2' then sum(faltas_coc_2)/count(*) else 0 end as faltas_coc_2,
        case when tpc_id = '2' then sum(numeroAulas_coc_2)/count(*) else 0 end as numeroAulas_coc_2,

        case when tpc_id = '3' then round(sum(freq_COC_3)/count(*), 2) else 0 end as freq_COC_3,
        case when tpc_id = '3' then sum(faltas_coc_3)/count(*) else 0 end as faltas_coc_3,
        case when tpc_id = '3' then sum(numeroAulas_coc_3)/count(*) else 0 end as numeroAulas_coc_3,

        case when tpc_id = '4' then round(sum(freq_COC_4)/count(*), 2) else 0 end as freq_COC_4,
        case when tpc_id = '4' then sum(faltas_coc_4)/count(*) else 0 end as faltas_coc_4,
        case when tpc_id = '4' then sum(numeroAulas_coc_4)/count(*) else 0 end as numeroAulas_coc_4,

        case when tpc_id = '5' then round(sum(freq_COC_5)/count(*), 2) else 0 end as freq_COC_5,
        case when tpc_id = '5' then sum(faltas_coc_5)/count(*) else 0 end as faltas_coc_5,
        case when tpc_id = '5' then sum(numeroAulas_coc_5)/count(*) else 0 end as numeroAulas_coc_5,

        sum(total_tempos)/count(*) as total_tempos,
        sum(total_faltas)/count(*) as total_faltas

    from (

        select
            frq.alu_id,
            frq.tpc_id,

            case when frq.tpc_id = '1' then round(((diasCoc * temposDia) - sum(IFNULL(taa_frequencia,0))) / CAST(diasCoc * temposDia AS FLOAT64) * 100, 2) else 0 end as freq_COC_1,
            case when frq.tpc_id = '1' then sum(IFNULL(taa_frequencia,0)) else 0 end as faltas_coc_1,
            case when frq.tpc_id = '1' then diasCoc * temposDia else 0 end as numeroAulas_coc_1,

            case when frq.tpc_id = '2' then round(((diasCoc * temposDia) - sum(IFNULL(taa_frequencia,0))) / CAST(diasCoc * temposDia AS FLOAT64) * 100, 2) else 0 end as freq_COC_2,
            case when frq.tpc_id = '2' then sum(IFNULL(taa_frequencia,0)) else 0 end as faltas_coc_2,
            case when frq.tpc_id = '2' then diasCoc * temposDia else 0 end as numeroAulas_coc_2,

            case when frq.tpc_id = '3' then round(((diasCoc * temposDia) - sum(IFNULL(taa_frequencia,0))) / CAST(diasCoc * temposDia AS FLOAT64) * 100, 2) else 0 end as freq_COC_3,
            case when frq.tpc_id = '3' then sum(IFNULL(taa_frequencia,0)) else 0 end as faltas_coc_3,
            case when frq.tpc_id = '3' then diasCoc * temposDia else 0 end as numeroAulas_coc_3,

            case when frq.tpc_id = '4' then round(((diasCoc * temposDia) - sum(IFNULL(taa_frequencia,0))) / CAST(diasCoc * temposDia AS FLOAT64) * 100, 2) else 0 end as freq_COC_4,
            case when frq.tpc_id = '4' then sum(IFNULL(taa_frequencia,0)) else 0 end as faltas_coc_4,
            case when frq.tpc_id = '4' then diasCoc * temposDia else 0 end as numeroAulas_coc_4,

            case when frq.tpc_id = '5' then round(((diasCoc * temposDia) - sum(IFNULL(taa_frequencia,0))) / CAST(diasCoc * temposDia AS FLOAT64) * 100, 2) else 0 end as freq_COC_5,
            case when frq.tpc_id = '5' then sum(IFNULL(taa_frequencia,0)) else 0 end as faltas_coc_5,
            case when frq.tpc_id = '5' then diasCoc * temposDia else 0 end as numeroAulas_coc_5,

            diasCoc * temposDia as total_tempos,
            sum(IFNULL(taa_frequencia,0)) as total_faltas

        from {{ ref('educacao_basica_frequencia__frq_frequencia') }} frq

        inner join {{ ref('brutos_gestao_escolar__aluno_curriculo') }} alc
            on alc.alu_id = frq.alu_id
            and alc.esc_id = frq.esc_id
            and alc.alc_situacao <> 3
            and frq.dataAula between alc.alc_dataPrimeiraMatricula and IFNULL(alc.alc_dataSaida, CURRENT_DATE())

        inner join frqtrn trn
            on trn.trn_id = frq.trn_id

        inner join diasCoc dia
            on dia.cal_id = frq.cal_id and dia.tpc_id = frq.tpc_id

        where tau_efetivado = 1

        group by
            frq.alu_id,
            frq.tpc_id,
            frq.cal_id,
            frq.trn_id,
            diasCoc,
            temposDia
    ) tab

    group by alu_id, tpc_id

), frqpri as (
    select
        alu_id,
        sum(total_tempos) as total_tempos,
        sum(total_faltas) as total_faltas,
        sum(freq_COC_1) as freq_coc1,
        sum(faltas_coc_1) as faltas_coc1,
        sum(numeroAulas_coc_1) as nm_aulas_coc1,
        sum(freq_COC_2) as freq_coc2,
        sum(faltas_coc_2) as faltas_coc2,
        sum(numeroAulas_coc_2) as nm_aulas_coc2,
        sum(freq_COC_3) as freq_coc3,
        sum(faltas_coc_3) as faltas_coc3,
        sum(numeroAulas_coc_3) as nm_aulas_coc3,
        sum(freq_COC_4) as freq_coc4,
        sum(faltas_coc_4) as faltas_coc4,
        sum(numeroAulas_coc_4) as nm_aulas_coc4,
        sum(freq_COC_5) as freq_coc5,
        sum(faltas_coc_5) as faltas_coc5,
        sum(numeroAulas_coc_5) as nm_aulas_coc5,
        case
            when sum(total_tempos) > 0 then
                round((sum(total_tempos) - sum(total_faltas)) / cast(sum(total_tempos) as float64) * 100, 2)
            else 0
        end as perc_freq_acumulada
    from frqbase
    group by alu_id
)

select
    frqpri.alu_id,
    alu.Ano,
    substr(esc.esc_codigo, 1, 2) as cre,
    esc.esc_id,
    esc.esc_codigo,
    esc.esc_nome,
    alu.tur_id,
    alu.Turma,
    alu.Nome as nome,
    alu.cpf,
    alu.matricula,
    alu.nis_aluno,
    alu.Raca_Cor as raca_cor,
    alu.sexo,
    alu.endereco,
    alu.bairro,
    alu.cep,
    alu.DataNascimento as data_nascimento,
    alu.Idade_Atual as idade_atual,
    alu.Idade_3112 as idade_3112,
    alu.cod_def,
    alu.Deficiencia as deficiencia,
    alu.situacao,
    alu.Cod_Ult_Mov as cod_ult_mov,
    alu.Ult_Movimentacao as ult_movimentacao,
    alu.filiacao_1,
    alu.filiacao_2,
    CAST(alu.celular_1 AS STRING) as celular1,
    CAST(alu.celular_2 AS STRING) as celular2,
    CAST(alu.telefone AS STRING) as telefone,
    CAST(alu.telefone_casa AS STRING) as telefone_casa,
    CAST(alu.telefone_recado AS STRING) as telefone_recado,
    CAST(alu.telefone_trab AS STRING) as telefone_trabalho,
    alu.nis_resp,
    alu.bolsa_familia,
    frqpri.total_tempos,
    frqpri.total_faltas,
    round(frqpri.perc_freq_acumulada, 2) as perc_freq_acumulada,
    round(100 - frqpri.perc_freq_acumulada, 2) as perc_faltas_acumulada,
    freq_coc1,
    faltas_coc1,
    nm_aulas_coc1,
    freq_coc2,
    faltas_coc2,
    nm_aulas_coc2,
    freq_coc3,
    faltas_coc3,
    nm_aulas_coc3,
    freq_coc4,
    faltas_coc4,
    nm_aulas_coc4,
    freq_coc5,
    faltas_coc5,
    nm_aulas_coc5
from {{ ref('brutos_gestao_escolar__vw_bi_aluno') }} alu
inner join {{ ref('brutos_gestao_escolar__tur_turma') }} tur on alu.tur_id = tur.tur_id and tur.tur_situacao = 1
inner join {{ ref('brutos_gestao_escolar__esc_escola') }} esc on esc.esc_id = tur.esc_id and esc.esc_situacao = 1
inner join frqpri on frqpri.alu_id = alu.alu_id

