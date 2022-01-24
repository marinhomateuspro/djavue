<template>
  <v-dialog v-model="visible" max-width="1500px">
    <v-window v-model="step">
      <v-window-item :value="2">
        <v-card>
          <v-card-title>Log in</v-card-title>
          <v-card-text>
            <v-container fluid>
              <v-text-field label="Username" required v-model="username" />
              <v-text-field label="Password" type="password" required v-model="password" @keyup.enter="login()" />
              <small style="color: red;" v-if="error">Wrong user or password</small>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer />
            <v-btn rounded outlined dark @click="step++">REGISTRAR</v-btn>
            <v-btn class="blue--text darken-1" text @click="close()">Cancel</v-btn>
            <v-btn class="blue--text darken-1" text @click="login()" :loading="loading" :disabled="loading">Login</v-btn>
          </v-card-actions>
        </v-card>
      </v-window-item>
      <v-window-item :value="3">
        <v-row class="fill-height">
          <v-col cols="12" md="4" class="primary">
            <v-row justify="center" class="ma-16">
              <img src="~/assets/logoWhite.png" style="max-height: 35px">
            </v-row>
            <v-card-text class="white--text mt-12">
              <h1 class="text-center display-1">Já tem uma conta?</h1>
            </v-card-text>
            <div class="text-center ma-12">
              <v-btn rounded outlined dark @click="step--">ENTRAR</v-btn>
            </div>
          </v-col>

          <v-col cols="12" md="8">
            <v-card-text class="mt-12">
              <h1 class="text-center display-2 primary--text">Registre-se</h1>
              <v-form ref="formRegister" v-model="validRegister" lazy-validation>
                <v-text-field label="Name" name="Name" prepend-icon="mdi-account" type="text" color="primary" v-model="timecard" required />
                <v-text-field
                  label="Cartão Ponto"
                  name="Cartão Ponto"
                  prepend-icon="mdi-card-bulleted-settings"
                  type="text"
                  color="primary"
                  v-model="timecard"
                  required
                />

                <v-select v-model="plant" :items="plants" :rules="[(v) => !!v || 'Item obrigatório']" color="primary" prepend-icon="mdi-map-marker" label="Planta" name="Planta" required />

                <v-text-field
                  label="Email"
                  name="Email"
                  prepend-icon="mdi-at"
                  type="text"
                  color="primary"
                  v-model="email"
                  required
                />

                <v-text-field
                  :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
                  :type="show ? 'text' : 'password'"
                  id="password"
                  label="Password"
                  name="password"
                  prepend-icon="mdi-lock"
                  color="primary"
                  v-model="password"
                  @click:append="show = !show"
                  required
                />

                <v-text-field
                  :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
                  :type="show ? 'text' : 'password'"
                  id="passwordCheck"
                  label="Password Verify"
                  name="password"
                  prepend-icon="mdi-lock"
                  color="primary"
                  v-model="passwordCheck"
                  @click:append="show = !show"
                  required
                />
              </v-form>
            </v-card-text>
            <div class="text-center mt-n5">
              <v-btn rounded color="primary" class="ma-12" @click="register()" dark>REGISTRAR</v-btn>
            </div>
          </v-col>
        </v-row>
      </v-window-item>
    </v-window>
  </v-dialog>
</template>

<script>

import api from '~api'

export default {
  data () {
    return {
      step: 2,
      visible: false,
      loading: false,
      username: '',
      password: '',
      error: false
    }
  },
  methods: {
    open () {
      this.visible = true
    },
    close () {
      this.visible = false
    },
    async login () {
      this.loading = true
      this.error = false
      const user = await api.login(this.username, this.password)
      if (user) {
        this.$store.commit('auth/setCurrentUser', user)
        this.visible = false
      } else {
        this.error = true
      }
      this.loading = false
    }
  }
}
</script>
