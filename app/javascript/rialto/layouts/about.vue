<template>
  <section class="container">
    <p>RIALTO is a research analytics system for Stanford University, developed by Stanford University Library, which builds on the Stanford wide "Research Information Ecosystem" initiative.  More information on RIALTO,  including documented use cases, can be found on the <a href="https://library.stanford.edu/projects/rialto/" rel="nofollow">library project page</a>.</p>
    <p>We are grateful for the support and advice from the Office of International Affairs, the Office of the Dean of Research,  Lane Medical Library, and Stanford University Library.</p>
    <p>Note that the reports and data shown in RIALTO may include data that is only available for use within Stanford University, and non-aggregated data should not be shared outside of Stanford.  Also note that the data used to generate reports is aggregated from the following sources:</p>

    <ul>
      <li>Researcher data from Stanford Profiles</li>
      <li>Stanford organization data from Stanford Profiles</li>
      <li>Publication data from the <a href="https://clarivate.com/products/web-of-science/" rel="nofollow">Web of Science</a></li>
      <li>Grant data from SeRA</li>
    </ul>

    <p>If you would like to use or share this data outside of Stanford, please <a href="mailto:rialto-contact@lists.stanford.edu?Subject=RIALTO" target="_top">contact us</a>.  We also welcome new use cases, suggestions of other interested parties, and sharing of how you have used this system.</p>

    <p>Some limitations of the data include, but are not limited to:</p>

    <ul>
      <li>not all publications are represented in the Web of Science, and coverage by subject area will vary</li>
      <li>only publications from authors currently at Stanford and published while at Stanford are included</li>
      <li>due to name ambiguities and the querying mechanism, there will be both false positive and false negative publication results in these aggregated counts</li>
      <li>research areas are determined at the level of a journal (so all publications in a given journal will have the same research areas)</li>
      <li>data is updated monthly, except for grant data from SeRA, which is currently a one-time load from January 2019 (note: we expect to have automated up-to-date grant data in the future)</li>
    </ul>
    <p>More detailed information about the data sources may be found on our <a href="https://github.com/sul-dlss/rialto/wiki/Data-Sources-and-Issues-with-Data">project wiki page</a>.</p>
  </section>
</template>


<script>
export default {
}
</script>

<style scoped>
.container {
  margin-top: 1rem;
}

</style>
