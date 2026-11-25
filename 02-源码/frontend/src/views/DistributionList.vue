<template>
  <div>
    <PageHead title="发放单跟踪" sub="发放单全流程：需求审核 → 分配出库 → 签收回执 → 追踪归档">
      <template #actions>
        <button class="btn" @click="$router.push('/application-list')">受助需求池</button>
        <button class="btn btn-primary" @click="$router.push('/distribute')">拣货作业台</button>
      </template>
    </PageHead>

    <div class="card">
      <ListPage :cfg="cfg">
        <template #ops="{ row }">
          <span class="link-op" @click="$router.push({ path: '/distribution-detail', query: { id: row.id } })">详情</span>
        </template>
      </ListPage>
    </div>
  </div>
</template>

<script setup>
import PageHead from '../components/PageHead.vue'
import ListPage from '../components/ListPage.vue'
import { pageDistribution } from '../api'
import { fmtNum } from '../utils/dict'

const cfg = {
  api: pageDistribution,
  pageSize: 10,
  filters: [
    { key: 'keyword', label: '关键字', ph: '发放单号 / 受助人', w: 'w-md' },
    { key: 'stage', label: '阶段', type: 'select', options: ['需求审核', '分配出库', '签收回执', '追踪归档'] },
    { key: 'status', label: '状态', type: 'select', options: ['待处理', '处理中', '已完成', '已退回', '已取消'] }
  ],
  columns: [
    { key: 'orderNo', type: 'mono', label: '发放单号', width: '150px' },
    { key: 'receiverName', label: '受助人', width: '100px' },
    { key: 'region', label: '区域', width: '100px' },
    { key: 'deliverType', label: '领取方式', width: '100px' },
    { key: 'totalQty', type: 'num', label: '物资合计', width: '90px' },
    { key: 'stage', type: 'tag', label: '当前阶段', width: '104px' },
    { key: 'status', type: 'tag', label: '状态', width: '88px' },
    { key: 'deadline', type: 'date', label: '要求完成', width: '104px' },
    { key: 'finishTime', type: 'time', label: '完成时间', width: '140px' }
  ]
}
</script>
