<template>
  <div>
    <PageHead title="物资与需求" sub="按项目维护物资需求条目，缺口数量自动随收货验收刷新">
      <template #actions>
        <button class="btn" @click="$router.push('/project-list')">查看捐赠项目</button>
        <button class="btn btn-primary" @click="$router.push('/intent-list')">登记捐赠意向</button>
      </template>
    </PageHead>

    <div class="card">
      <ListPage :cfg="cfg">
        <template #ops="{ row }">
          <span class="link-op" @click="$router.push('/intent-list')">去募集</span>
          <span class="link-op" @click="showRow(row)">明细</span>
        </template>
      </ListPage>
    </div>

    <el-dialog v-model="dialog" title="需求条目明细" width="520px">
      <div class="summary-box">
        <div class="row"><span>需求编号</span><b>{{ cur.demandNo }}</b></div>
        <div class="row"><span>物资名称</span><b>{{ cur.materialName }}</b></div>
        <div class="row"><span>类别 / 规格</span><b>{{ cur.category }} · {{ cur.spec }}</b></div>
        <div class="row"><span>需求数量</span><b>{{ fmtNum(cur.demandQty, cur.unit) }}</b></div>
        <div class="row"><span>已收数量</span><b>{{ fmtNum(cur.receivedQty, cur.unit) }}</b></div>
        <div class="row"><span>缺口数量</span><b>{{ fmtNum(cur.gapQty, cur.unit) }}</b></div>
        <div class="row"><span>紧急程度</span><b>{{ cur.urgency }}</b></div>
        <div class="row"><span>接收质量要求</span><b>{{ cur.acceptQuality }}</b></div>
        <div class="row"><span>保质期要求</span><b>{{ cur.shelfLifeReq || '无特殊要求' }}</b></div>
      </div>
      <div class="rule-note">{{ cur.remark || '暂无备注' }}</div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import PageHead from '../components/PageHead.vue'
import ListPage from '../components/ListPage.vue'
import { pageDemand } from '../api'
import { CATEGORY, fmtNum } from '../utils/dict'

const dialog = ref(false)
const cur = ref({})

const cfg = {
  api: pageDemand,
  pageSize: 10,
  filters: [
    { key: 'keyword', label: '物资名称', w: 'w-md' },
    { key: 'category', label: '类别', type: 'select', options: CATEGORY },
    { key: 'gapStatus', label: '缺口情况', type: 'select', options: ['缺口较大', '接近达标', '已满足'] }
  ],
  columns: [
    { key: 'demandNo', type: 'mono', label: '需求编号', width: '150px' },
    { key: 'materialName', type: 'two', label: '物资', main: 'materialName', sub: 'spec', width: '190px' },
    { key: 'category', label: '类别', width: '94px' },
    { key: 'demandQty', type: 'num', label: '需求', width: '70px' },
    { key: 'receivedQty', type: 'num', label: '已收', width: '70px' },
    { key: 'gapQty', type: 'num', label: '缺口', width: '70px' },
    { key: 'urgency', type: 'tag', label: '紧急度', width: '82px' },
    { key: 'acceptQuality', label: '质量要求', width: '150px' },
    { key: 'status', type: 'tag', label: '状态', width: '74px' }
  ]
}

function showRow(row) {
  cur.value = row
  dialog.value = true
}
</script>
