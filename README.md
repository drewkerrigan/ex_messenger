# ExMessenger

An OTP Messaging Platform in Elixir

## Tutorial: Creating a concurrent messaging platform in Elixir

### Getting Started

Start with a basic project

```
mix new ex_messenger
```

This creates an OTP `Application` and `Supervisor` for us.

Application: `lib/ex_messenger.ex`

Supervisor: `lib/ex_messenger/supervisor.ex`





Clients will do Node.connect on server and then issue commands from there ( to join rooms / games / etc)

For the blackjack portion, GenFSM could be cool to implement the states of a Blackjack game