# Stoic-DOT
# Management System Resource

## Description
This resource provides a management system for departments in FiveM servers. It allows administrators to view and manage department employees and balance. The system is implemented in Lua using NDCore.

## Features
- View and manage department employees.
- Add and remove funds from the department balance.
- View current department balance.
- User-friendly interface with context menus.
- Includes additional commands: `/upcharge`, `/opendot`, `/aaa`.

## Installation
1. Clone or download this repository.
2. Place the `Stoic-DOT` folder in your FiveM server's resources directory.
3. Add `ensure Stoic-DOT` to your `server.cfg` to ensure the resource starts when the server boots up.
4. Ensure you have `oxmysql` installed and configured to use MySQL database for storing department data.

## Usage
1. Start your FiveM server.
2. In-game, use the command `/management` to open the management menu. [WIP]
3. From the management menu, you can navigate through various options to view and manage department employees and balance.
4. Use additional commands for specific functionalities:
   - `/upcharge [targetId]`: Opens an upcharge input dialog to charge a specified player.
   - `/opendot`: Opens the Department of Transportation (DOT) management interface.
   - `/aaa`: Opens the AAA payment input dialog allowing the user to make a payment with a description and select a department. The user's location will be automatically retrieved and included in the payment information.

## Dependencies
- [oxmysql](https://github.com/overextended/oxmysql)
