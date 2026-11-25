<template>
  <div>
    <div class="page-head">
      <div>
        <h1>{{ title }}</h1>
        <p v-if="sub">{{ sub }}</p>
      </div>
      <div class="actions">
        <slot name="actions" />
      </div>
    </div>
    <slot />
  </div>
</template>

<script setup>
defineProps({
  title: { type: String, default: '' },
  sub: { type: String, default: '' }
})
</script>
