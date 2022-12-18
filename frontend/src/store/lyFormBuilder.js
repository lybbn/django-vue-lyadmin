/**
 * author: lybbn
 * program django-vue-lyadmin
 * email: 1042594286@qq.com
 * website: http://www.lybbn.cn
 * date: 2022.11.17
 * remark: 如果要分发django-vue-lyadmin源码或其中组件等，需在本文件顶部保留此文件头信息！！！
 */
import { defineStore } from 'pinia'
import {randomId, parseString2Json,getDefaultFormConfig} from '@/utils/util'
import {lyContainers, lyBasicFields, lyAdvancedFields, lyCustomFields} from "@/components/lyform-builder/lywidget-pannel/lyWidgetConfig"
import {LYFORMBUILDER_VERSION} from "@/components/lyform-builder/config"

export const useBuilderStore = defineStore('lyFormBuilder', {
    state:() => {
        return {
            widgetList: [],
            formConfig: {},
            selectedId: null,
            selectedWidget: {},
            selectedWidgetName: null,
            formWidget:null,
            allWidgets:[...lyContainers, ...lyBasicFields, ...lyAdvancedFields, ...lyCustomFields],
            historyData: {
                index: -1,
                maxStep: 20,
                steps: [],
            },
            builderConfig:null,
            defaultFormConfig:parseString2Json(getDefaultFormConfig())
        }
    },
    getters:{

    },
    actions: {
        initBuilder(){
            this.widgetList = []
            this.formConfig = parseString2Json(this.defaultFormConfig)
            this.allWidgets = [...lyContainers, ...lyBasicFields, ...lyAdvancedFields, ...lyCustomFields]
            console.info(`%clyFormBuilder %cVer${LYFORMBUILDER_VERSION} %chttps://www.lybbn.cn/`,
              "color:#409EFF;font-size: 22px;font-weight:bolder",
              "color:#999;font-size: 12px",
              "color:#333"
            )
            this.initHistoryData()
        },
        initHistoryData(){
            this.loadFormContentFromStorage()
            this.historyData.index++
            this.historyData.steps[this.historyData.index] = ({
                widgetList: parseString2Json(this.widgetList),
                formConfig: parseString2Json(this.formConfig)
            })
        },
        clearBuilder(skipHistoryChange){
            let emptyWidgetListFlag = (this.widgetList.length === 0)
            this.widgetList = []
            this.selectedId = null
            this.selectedWidgetName = null
            this.selectedWidget = {}
            this.formConfig = parseString2Json(this.defaultFormConfig)

            if (!!skipHistoryChange) {
            } else if (!emptyWidgetListFlag) {
                this.emitHistoryChange()
            } else {
                this.saveCurrentHistoryStep()
            }
        },
        registerFormWidget(formWidget) {
            this.formWidget = formWidget
        },
        loadFormJson(formJson) {
            let modifiedFlag = false
            if (!!formJson && !!formJson.widgetList) {
                this.widgetList = formJson.widgetList
                modifiedFlag = true
            }
            if (!!formJson && !!formJson.formConfig) {
                this.formConfig = importObj.formConfig
                modifiedFlag = true
            }

            if (modifiedFlag) {
                this.emitEvent('form-json-imported', [])
            }
            return modifiedFlag
        },
        setSelected(selected) {
            if (!selected) {
                this.clearSelected()
                return
            }
            this.selectedWidget = selected
            if (!!selected.id) {
                this.selectedId = selected.id
                this.selectedWidgetName = selected.options.name
            }
        },
        clearSelected() {
            this.selectedId = null
            this.selectedWidgetName = null
            this.selectedWidget = {}
        },
        emitHistoryChange() {
            if (this.historyData.index === this.historyData.maxStep - 1) {
                this.historyData.steps.shift()
            } else {
                this.historyData.index++
            }
            this.historyData.steps[this.historyData.index] = ({
                widgetList: parseString2Json(this.widgetList),
                formConfig: parseString2Json(this.formConfig)
            })

            this.saveFormContentToStorage()

            if (this.historyData.index < this.historyData.steps.length - 1) {
                this.historyData.steps = this.historyData.steps.slice(0, this.historyData.index + 1)
            }
        },
        handleWidgetMove(e) {
            if (!!e.draggedContext && !!e.draggedContext.element) {
                let category = e.draggedContext.element.category
                if (!!e.to) {
                    if ((e.to.className === 'sub-form-table') && (category === 'container')) {
                        return false
                    }
                }
            }
            return true
        },
        handleFieldMove(e) {
            if (!!e.draggedContext && !!e.draggedContext.element) {
                let wgCategory = e.draggedContext.element.category
                let wgType = e.draggedContext.element.type + ''
                if (!!e.to) {
                    if ((e.to.className === 'sub-form-table') && (wgType === 'slot')) {
                        return false
                    }
                }
            }
            return true
        },
        cloneContainer(containWidget) {
            if (containWidget.type === 'grid') {
                let newGrid = parseString2Json(this.getContainerByType('grid'))
                newGrid.id = newGrid.type + randomId()
                newGrid.options.name = newGrid.id
                containWidget.cols.forEach(gridCol => {
                    let newGridCol = parseString2Json(this.getContainerByType('grid-col'))
                    let tmpId = randomId()
                    newGridCol.id = 'grid-col-' + tmpId
                    newGridCol.options.name = 'gridCol' + tmpId
                    newGridCol.options.span = gridCol.options.span
                    newGrid.cols.push(newGridCol)
                })
                return newGrid
            }
            else if (containWidget.type === 'table') {
                let newTable = parseString2Json(this.getContainerByType('table'))
                newTable.id = newTable.type + randomId()
                newTable.options.name = newTable.id
                containWidget.rows.forEach(tRow => {
                    let newRow = parseString2Json(tRow)
                    newRow.id = 'table-row-' + randomId()
                    newRow.cols.forEach(col => {
                        col.id = 'table-cell-' + randomId()
                        col.options.name = col.id
                        col.widgetList = []  //清空组件列表
                    })
                    newTable.rows.push(newRow)
                })
                return newTable
            }
            else {
                return null
            }
        },
        moveUpWidget(parentList, indexOfParentList) {
            if (!!parentList) {
                if (indexOfParentList === 0) {
                    return
                }

                let tempWidget = parentList[indexOfParentList]
                parentList.splice(indexOfParentList, 1)
                parentList.splice(indexOfParentList - 1, 0, tempWidget)
            }
        },

        moveDownWidget(parentList, indexOfParentList) {
            if (!!parentList) {
                if (indexOfParentList === parentList.length - 1) {
                    return
                }

                let tempWidget = parentList[indexOfParentList]
                parentList.splice(indexOfParentList, 1)
                parentList.splice(indexOfParentList + 1, 0, tempWidget)
            }
        },
        appendTableRow(widget) {
            let rowIdx = widget.rows.length//确定插入行位置
            let newRow = parseString2Json(widget.rows[widget.rows.length - 1])
            newRow.id = 'table-row-' + generateId()
            newRow.merged = false
            newRow.cols.forEach(col => {
                col.id = 'table-cell-' + generateId()
                col.options.name = col.id
                col.merged = false
                col.options.colspan = 1
                col.options.rowspan = 1
                col.widgetList.length = 0
            })
            widget.rows.splice(rowIdx, 0, newRow)
            this.emitHistoryChange()
        },
        appendTableCol(widget) {
            let colIdx = widget.rows[0].cols.length  //确定插入列位置
            widget.rows.forEach(row => {
            let newCol = parseString2Json(this.getContainerByType('table-cell'))
            newCol.id = 'table-cell-' + randomId()
            newCol.options.name = newCol.id
            newCol.merged = false
            newCol.options.colspan = 1
            newCol.options.rowspan = 1
            newCol.widgetList.length = 0
            row.cols.splice(colIdx, 0, newCol)
        })

            this.emitHistoryChange()
        },
        addContainerByDbClick(container) {
            let newCon = this.cloneNewContainerWidget(container)
            this.widgetList.push(newCon)
            this.setSelected(newCon)
            this.saveCurrentHistoryStep()
        },
        addFieldByDbClick(widget) {
            let newWidget = this.cloneNewFieldWidget(widget)
            if (!!this.selectedWidget && this.selectedWidget.type === 'tab') {
                //获取当前激活的tabPane
                let activeTab = this.selectedWidget.tabs[0]
                this.selectedWidget.tabs.forEach(tabPane => {
                    if (!!tabPane.options.active) {
                        activeTab = tabPane
                    }
                })

                !!activeTab && activeTab.widgetList.push(newWidget)
            } else if (!!this.selectedWidget && !!this.selectedWidget.widgetList) {
                this.selectedWidget.widgetList.push(newWidget)
            } else {
                this.widgetList.push(newWidget)
            }

            this.setSelected(newWidget)
            this.emitHistoryChange()
        },
        cloneGridCol(widget, parentWidget) {
            let newGridCol = parseString2Json(this.getContainerByType('grid-col'))
            newGridCol.options.span = widget.options.span
            let tmpId = randomId()
            newGridCol.id = 'grid-col-' + tmpId
            newGridCol.options.name = 'gridCol' + tmpId
            parentWidget.cols.push(newGridCol)
        },
        deleteColOfGrid(gridWidget, colIdx) {
            if (!!gridWidget && !!gridWidget.cols) {
                gridWidget.cols.splice(colIdx, 1)
            }
        },

        addNewColOfGrid(gridWidget) {
            const cols = gridWidget.cols
            let newGridCol = parseString2Json(this.getContainerByType('grid-col'))
            let tmpId = randomId()
            newGridCol.id = 'grid-col-' + tmpId
            newGridCol.options.name = 'gridCol' + tmpId
            if ((!!cols) && (cols.length > 0)) {
                let spanSum = 0
                cols.forEach((col) => {
                    spanSum += col.options.span
                })

                if (spanSum >= 24) {
                    console.log('列栅格之和超出24')
                    gridWidget.cols.push(newGridCol)
                } else {
                    newGridCol.options.span = (24 - spanSum) > 12 ? 12 : (24 - spanSum)
                    gridWidget.cols.push(newGridCol)
                }
            } else {
                gridWidget.cols = [newGridCol]
            }
        },
        cloneNewFieldWidget(origin) {
            let newWidget = parseString2Json(origin)
            let tempId = randomId()
            newWidget.id = newWidget.type.replace(/-/g, '') + tempId
            newWidget.options.name = newWidget.id
            newWidget.options.label = newWidget.options.label || newWidget.type.toLowerCase()
            // delete newWidget.displayName
            return newWidget
        },
        cloneNewContainerWidget(item) {
            let newCW = parseString2Json(item)
            newCW.id = newCW.type.replace(/-/g, '') + randomId()
            newCW.options.name = newCW.id
            if (newCW.type === 'grid') {
                let newCol = parseString2Json( this.getContainerByType('grid-col') )
                let tmpId = randomId()
                newCol.id = 'grid-col-' + tmpId
                newCol.options.name = 'gridCol'+ tmpId
                newCW.cols.push(newCol)
                newCol = parseString2Json(newCol)
                tmpId = randomId()
                newCol.id = 'grid-col-' + tmpId
                newCol.options.name = 'gridCol' + tmpId
                newCW.cols.push(newCol)
            } else if (newCW.type === 'table') {
                let newRow = {cols: []}
                newRow.id = 'table-row-' + randomId()
                newRow.merged = false
                let newCell = parseString2Json( this.getContainerByType('table-cell') )
                newCell.id = 'table-cell-' + randomId()
                newCell.options.name = newCell.id
                newCell.merged = false
                newCell.options.colspan = 1
                newCell.options.rowspan = 1
                newRow.cols.push(newCell)
                newCW.rows.push(newRow)
            } else if (newCW.type === 'tab') {
                let newTabPane = parseString2Json( this.getContainerByType('tab-pane') )
                newTabPane.id = 'tab-pane-' + randomId()
                newTabPane.options.name = 'tab1'
                newTabPane.options.label = 'tab1'
                newCW.tabs.push(newTabPane)
            }
            // delete newCW.displayName
            return newCW
        },
        getContainerByType(typeName) {
            return  this.allWidgets.find(item => !!item.type && (item.type === typeName))
        },
        saveFormContentToStorage() {
            window.localStorage.setItem('lyformbuilder_widget__list__backup', JSON.stringify(this.widgetList))
            window.localStorage.setItem('lyformbuilder_form__config__backup', JSON.stringify(this.formConfig))
        },
        loadFormContentFromStorage() {
            let widgetListBackup = window.localStorage.getItem('lyformbuilder_widget__list__backup')
            if (!!widgetListBackup) {
                this.widgetList = JSON.parse(widgetListBackup)
            }
            let formConfigBackup = window.localStorage.getItem('lyformbuilder_form__config__backup')
            if (!!formConfigBackup) {
                this.formConfig = JSON.parse(formConfigBackup)
            }
        },
        saveCurrentHistoryStep() {
            this.historyData.steps[this.historyData.index] = parseString2Json({
                widgetList: this.widgetList,
                formConfig: this.formConfig
            })
            this.saveFormContentToStorage()
        }
    },
})