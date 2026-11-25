<template>
  <div>
    <PageHead title="受助需求池" sub="受助人提交的物资申领需求，按紧迫度排序进入资格审核">
      <template #actions>
        <button class="btn" @click="$router.push('/applicant')">受助申请端</button>
        <button class="btn btn-primary" @click="$router.push('/application-review')">进入审核台</button>
      </template>
    </PageHead>

    <div class="card">
      <ListPage :cfg="cfg">
        <template #ops="{ row }">
          <span class="link-op" @click="$router.push({ path: '/application-review', query: { id: row.id } })">审核</span>
          <span class="link-op" @click="$router.push({ path: '/distribution-list', query: { applyNo: row.applyNo } })">发放单</span>
        </template>
      </ListPage>
    </div>
  </div>
</template>

<script setup>
import PageHead from '../components/PageHead.vue'
import ListPage from '../components/ListPage.vue'
import { pageApplication } from '../api'
import { REGION } from '../utils/dict'

const cfg = {
  api: pageApplication,
  pageSize: 10,
  filters: [
    { key: 'keyword', label: '关键字', ph: '申请编号 / 申请人', w: 'w-md' },
    { key: 'status', label: '状态', type: 'select', options: ['待审核', '待拣货', '待领用', '待配送', '待反馈', '已完成', '已退回', '已取消'] },
    { key: 'urgencyLevel', label: '紧迫度', type: 'select', options: ['特急', '紧急', '一般'] },
    { key: 'region', label: '区域', type: 'select', options: REGION }
  ],
  columns: [
    { key: 'applyNo', type: 'mono', label: '申请编号', width: '150px' },
    { key: 'applicantName', type: 'two', label: '申请人', main: 'applicantName', sub: 'applyType', width: '140px' },
    { key: 'region', label: '所属区域', width: '100px' },
    { key: 'familySize', type: 'num', label: '家庭人数', width: '90px' },
    { key: 'urgencyLevel', type: 'tag', label: '紧迫度', width: '84px' },
    { key: 'purpose', label: '申领用途', width: '190px' },
    { key: 'distributeType', label: '领取方式', width: '96px' },
    { key: 'applyTime', type: 'time', label: '申请时间', width: '140px' },
    { key: 'status', type: 'tag', label: '状态', width: '88px' }
  ]
}
</script>
