import { assert } from 'chai'
import { mount } from '@vue/test-utils'
import HttpError from 'blacklight/mixins/httpError'
import Vue from "vue";

describe('HttpError', () => {
    var Component = Vue.extend({
        mixins: [HttpError]
    })

    it("ignores a null error", () => {
        const wrapper = mount(Component)

        assert.isFalse(wrapper.vm.handleHttpError(null))
    })

    it("return false when encounters error", () => {
        const wrapper = mount(Component)

        const error = {status: 500}

        assert.isTrue(wrapper.vm.handleHttpError(error))
    })

})
