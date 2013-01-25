{**
@Abstract Cad.App consts
@Author Prof1983 <prof1983@ya.ru>
@Created 26.04.2011
@LastMod 25.01.2013
}
unit CadAppConsts;

interface

resourcestring
  ERROR_LOADING = 'Ошибка загрузки документа';
  SMenuBookmarksText = 'Избранное';
  SMenuFileText = 'Файл';
  SMenuSprav = 'Справочники';
  SMenuTasksText = 'Задачи';
  SMenuToolsText = 'Сервис';
  SMenuViewText = 'Вид';
  SMenuVpText = 'Выр.пространство';
  SMenuWaysText = 'Пути выхода';
  SBookmarkMenuAdd = 'Добавить в избранное ...';
  SBookmarkMenuDelete = 'Удалить из избранного ...';
  SFileMenuImportCooling = 'Импорт всей схемы Cooling';
  SFileMenuImportCoolingAdd = 'Добавить новые ветви из схемы Cooling';
  SFileMenuImportDan = 'Импорт из файла .dan';
  SFileMenuImportFromExcel = 'Импорт факт. расходов из файла Excel';
  SFileMenuImportFtFromVs = 'Импорт факт. расходов из БД VentSys';
  SFileMenuNew = 'Новый';
  SFileMenuOpen = 'Открыть';
  SFileMenuSave = 'Сохранить';
  SFileMenuSaveAs = 'Сохранить как...';
  SSpravMenuVen = 'Вентиляторы';
  SSpravMenuVu = 'База вент. устройств';
  STaskMenuCalcWindow = 'Расчет сопротивления окна';
  STaskMenuDeviceStabilityCur = 'Рассчитать отказ вентиляционного устройства';
  STaskMenuDeviceStabilitySvod = 'Сводный расчет устойчивости для вент.устр.';
  STaskMenuEr = 'Нормальное воздухораспределение';
  STaskMenuGenDan = 'Сгенерировать расчетные данные по рисунку';
  STaskMenuIr = 'Идеальн.распределение';
  STaskMenuOr = 'Опт.распределение';
  STaskMenuEq = 'Проверяет соответствие схемы и расчета';
  STaskMenuEt = 'Расчет естественной тяги';
  STaskMenuSvish = 'Стрелки: свежая - исходящая';
  SToolMenuAddBase = 'Добавить в базу';
  SToolMenuCalculator = 'Калькулятор';
  SToolMenuChangeScale = 'Уменьшение или увеличение координат';
  SToolMenuCutBranch = 'Разбить ветвь';
  SToolMenuDeleteParasiteBranchs = 'Удалить ветви с отрицательными номерами';
  SToolMenuDeleteTupik = 'Удаление тупиков';
  SToolMenuLegendEditor = 'Редактор условных обозначений';
  SToolMenuPlaSearch = 'Найти позицию ПЛА';
  SToolMenuPrinterSetup = 'Окно выбора и настройки печати';
  SToolMenuRecovery = 'Проверка и исправление схемы';
  SToolMenuResetBranch = 'Сброс параметров ветви';
  SToolMenuResetBranchAll = 'Сброс параметров всех ветвей';
  SToolMenuRotateBr = 'Перевернуть ветвь';
  SToolMenuSearchBranch = 'Найти ветвь';
  SToolMenuSearchNode = 'Найти узел';
  SToolMenuSettings = 'Настройки...';
  SToolMenuVentOzCur = 'Расчитать очистной забой в выделенной ветви';
  SToolMenuZamSt = 'Показать/скрыть замеры';
  SViewMenuArrow = 'Направление движения воздуха';
  SViewMenuBranchName = 'Отобразить/скрыть отрисовку имен ветвей';
  SViewMenuChangeDataQ = 'Показать/скрыть факт. расход воздуха';
  SViewMenuData = 'Показать/скрыть расчетные данные';
  SViewMenuDavl = 'Показать/скрыть давление в узлах';
  SViewMenuGrid = 'Отобразить/скрыть сетку';
  SViewMenuNodeNum = 'Отобразить/скрыть отрисовку номеров узлов';
  SViewMenuShowAll = 'Показать все объекты';
  SViewMenuShowNorm = 'Нормальное распределение';
  SViewMenuShowOtrVetvi = 'Показать ветви с отрицательным расходом';
  SViewMenuShowPla = 'План ликвидации аварии';
  SViewMenuShowRas = 'Расчетная схема';
  SViewMenuShowRReg = 'Ветви с заданным R';
  SViewMenuShowSchema5 = 'Схема ...';
  SViewMenuShowVent = 'Схема вентиляции';
  SWayMenuChoose = 'Выбрать ветвь на схеме';
  SWayMenuClose = 'Закрыть форму "Маршруты"';
  SWayMenuCreate = 'Построить маршрут';
  SWayMenuEdit = 'Редактировать маршрут';
  SWayMenuList = 'Выбрать ветвь из списка';
  SWayMenuOpen = 'Перейти к форме "Маршруты"';
  SWayMenuSave = 'Сохранить маршрут';
  SWayMenuSaver = 'Маршруты спасателей (ВГСЧ)';
  SWayMenuTrash = 'Очистить список исключенных ветвей';
  SWayMenuView = 'Показать маршрут';
  SWayMenuWorker = 'Маршруты вывода горнорабочих';

implementation

end.
 