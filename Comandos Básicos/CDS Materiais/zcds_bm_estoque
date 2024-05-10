@AbapCatalog.sqlViewName: 'ZCDS_BM_ARMAZEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Aprendizado de CDS View com ABAP'
define view ZCDS_BM_ESTOQUE
  as select from mat_stock  as Stock
    inner join   storehouse as Store on Store.whnr = Stock.whnr
{
  Stock.whnr,
  Store.description,
  Store.regio,
  sum( Stock.quantity) as quantity
}
group by Stock.whnr, Store.description, Store.regio;
