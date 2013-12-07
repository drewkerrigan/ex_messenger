# ExMessenger

An OTP Messaging Platform in Elixir

## Usage

```
iex --sname server --cookie chocolate-chip -S mix
```

## Tutorial: Creating a concurrent messaging platform in Elixir

### Getting Started

Start with a basic project

```
mix new ex_messenger
```

This creates an OTP `Application` and `Supervisor` for us.

Application: `lib/ex_messenger.ex`

Supervisor: `lib/ex_messenger/supervisor.ex`
