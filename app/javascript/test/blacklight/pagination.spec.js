import { expect } from 'chai'
import { shallowMount } from '@vue/test-utils'
import Pagination from 'blacklight/search/pagination'
import Result from 'blacklight/search/result'

describe('result', () => {
  it("shows nothing while loading", () => {
    const wrapper = shallowMount(Pagination, {
      propsData: {
        result: new Result()
      }
    })
    expect(wrapper.find('div').text()).to.eq('')
  })

  it("shows no results", () => {
    const wrapper = shallowMount(Pagination, {
      propsData: {
        result: new Result({meta: {pages: { total_count: 0 }}, links: {}, included: []})
      }
    })
    expect(wrapper.find('div').text()).to.eq('No results matched your search.')
  })


    it("shows results", () => {
      const wrapper = shallowMount(Pagination, {
        propsData: {
          result: new Result({
            meta: {
              pages: {
                current_page:	2,
                next_page:	3,
                prev_page:	1,
                total_pages:	12132,
                limit_value:	10,
                offset_value:	10,
                total_count:	121311,
                'first_page?':	false,
                'last_page?':	false,
              }
            },
            links: {}, included: []
          })
        }
      })
      expect(wrapper.find('div').text()).to.have.string('11 - 20 of 121311')
    })

})
