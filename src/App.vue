<template>
  <div id="app">
    <div class="container-lg px-4 mb-6">
      <div class="text-center py-5">
        <img src="@/assets/logo.svg" height="64" />
        <h2>Balancer bounties</h2>
      </div>
      <div class="mb-5 d-flex flex-items-center rounded-3 px-4 bg-gray">
        <i class="iconfont iconsearch mb-1 mr-2" style="font-size: 22px;" />
        <input
          v-model="q"
          placeholder="Search by title, issue or tag"
          class="width-full border-0"
          style="line-height: 60px; font-size: 20px;"
        />
      </div>
      <div
        class="d-flex text-uppercase border-bottom pb-3 hide-sm hide-md"
        style="font-size: 15px;"
      >
        <div class="col-1">Issue</div>
        <div class="flex-auto">Title</div>
        <div class="col-2">Bounty</div>
        <div class="col-2">Claimed by</div>
      </div>
      <div
        v-for="(bounty, i) in filteredBounties"
        :key="i"
        class="d-block d-md-flex border-bottom py-3"
      >
        <div class="col-12 col-md-1">
          <h2>{{ bounty.issue }}</h2>
        </div>
        <div class="flex-auto">
          <a :href="bounty.link" target="_blank">
            <h2 class="mb-2">{{ bounty.title }}</h2>
          </a>
          <div class="mb-2">
            <span v-for="tag in bounty.tags" :key="tag" class="label mr-2">
              {{ tag }}
            </span>
          </div>
        </div>
        <div class="col-12 col-md-2">{{ bounty.bounty }}</div>
        <div class="col-12 col-md-2">
          <a
              v-if="bounty['claimed by']"
            :href="`https://github.com/${bounty['claimed by']}`"
            target="_blank"
          >
            @{{ bounty['claimed by'] }}
          </a>
          <template v-else>-</template>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
const id = '1VZpcv11xIxm_H9uVNG1oEpYbroR-5SBkvXXMvJCUedA';
const url = `https://spreadsheets.google.com/feeds/cells/${id}/1/public/full?alt=json`;

const getSpreadsheet = async url => {
  const spreadsheet = {};
  const columnsNames = {};
  await fetch(url)
    .then(res => res.json())
    .then(json => {
      json.feed.entry.forEach(entry => {
        const { col, row, inputValue } = entry['gs$cell'];
        if (row === '1') {
          columnsNames[col] = inputValue.toLowerCase();
        } else {
          const updatedRow = spreadsheet[row] || {};
          updatedRow[columnsNames[col]] = inputValue;
          spreadsheet[row] = updatedRow;
        }
      });
    });
  return spreadsheet;
};

export default {
  data() {
    return {
      q: '',
      bounties: {}
    };
  },
  async created() {
    const bounties = await getSpreadsheet(url);
    this.bounties = Object.fromEntries(
      Object.entries(bounties).map(bounty => {
        bounty[1].tags = bounty[1].tags.split(',').map(tag => tag.trim());
        return bounty;
      })
    );
    console.log(this.bounties);
  },
  computed: {
    filteredBounties() {
      return Object.fromEntries(
        Object.entries(this.bounties).filter(bounty =>
          JSON.stringify(bounty)
            .toLowerCase()
            .includes(this.q.toLowerCase())
        )
      );
    }
  }
};
</script>

<style lang="scss">
@import '~@primer/css/index.scss';
@import '//at.alicdn.com/t/font_1946815_x1zw6bzu1ee.css';

@font-face {
  font-family: 'Calibre';
  src: url('./assets/fonts/Calibre-Medium.eot');
  src: url('./assets/fonts/Calibre-Medium.eot?#iefix')
      format('embedded-opentype'),
    url('./assets/fonts/Calibre-Medium.woff') format('woff'),
    url('./assets/fonts/Calibre-Medium.ttf') format('truetype');
  font-weight: 500;
  font-style: normal;
}

@font-face {
  font-family: 'Calibre';
  src: url('./assets/fonts/Calibre-Semibold.eot');
  src: url('./assets/fonts/Calibre-Semibold.eot?#iefix')
      format('embedded-opentype'),
    url('./assets/fonts/Calibre-Semibold.woff') format('woff'),
    url('./assets/fonts/Calibre-Semibold.ttf') format('truetype');
  font-weight: 600;
  font-style: normal;
}

#app {
  font-family: 'Calibre', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  font-size: 18px;
}

.label {
  font-size: 16px;
  padding: 6px 10px 3px;
}

input {
  outline: none;
  background: transparent;
}
</style>
