# ExMessenger

An OTP Messaging Platform in Elixir

## Usage

```
iex --sname server --cookie chocolate-chip -S mix
```

## Resources

Client for this server: [https://github.com/drewkerrigan/ex_messenger_client](https://github.com/drewkerrigan/ex_messenger_client)

Blackjack library: [https://github.com/drewkerrigan/ex_cards](https://github.com/drewkerrigan/ex_cards)

## Tutorial: Creating a concurrent messaging platform in Elixir

### Getting Started

Start with a basic project

```
mix new ex_messenger
```

This creates an OTP `Application` and `Supervisor` for us.

Application: `lib/ex_messenger.ex`

Supervisor: `lib/ex_messenger/supervisor.ex`