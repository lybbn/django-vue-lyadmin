<script>
    import { h } from 'vue';
    export default {
        name:"LyRender",
        props: {
            row: Object,
            render: Function,
            index: Number,
            column: {
                type: Object,
                default: null
            }
        },
        render() {
            return this.render(this.row)
        }
    }
</script>