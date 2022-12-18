import { ref, onMounted ,nextTick,defineProps} from 'vue'
import { useBuilderStore } from "@/store/lyFormBuilder";

export default function() {

    const builderStore = useBuilderStore()

    function selectWidget(widget,designState=true) {
        if(designState){
            builderStore.setSelected(widget)
        }
    }

    function selectParentWidget(parentWidget) {
        if (parentWidget) {
            builderStore.setSelected(parentWidget)
        } else {
            builderStore.clearSelected()
        }
    }

    onMounted(() => {

    })

    return {
        selectWidget,
        selectParentWidget
    }
}