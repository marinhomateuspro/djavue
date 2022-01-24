<template>
  <v-footer app>
    <v-spacer />
    <span> Mateus Marinho &copy; {{ new Date().getFullYear() }}</span>
    <v-spacer />
  </v-footer>
</template>

<script>
export default {
  props: ['state']
}
</script>
