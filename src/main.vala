/**
 * RSSI tracker for the indicator applet.
 *
 * Reads RSSI value from an HTTP endpoint, displays value and proper 3G icon
 * in the tray.  Has a menu item to open detailed info (another URL).
 *
 * Inspiration: http://bazaar.launchpad.net/~indicator-applet-developers/libappindicator/trunk.15.10/view/head:/bindings/vala/examples/indicator-example.vala
 **/

using Gtk;
using AppIndicator;
using Soup;

public class Application : Window
{
    private Indicator tray;

    private int rssi;

    public Application()
    {
        this.title = "Indicator Test";
        this.window_position = WindowPosition.CENTER;
        this.border_width = 10;
        this.set_default_size(500, 400);

        this.destroy.connect(Gtk.main_quit);

        this.create_widgets();
        this.create_indicator();
    }

    public void create_widgets()
    {
    }

    public void create_indicator()
    {
        tray = new Indicator(this.title, "gsm-3g-none", IndicatorCategory.APPLICATION_STATUS);

        if (!(tray is Indicator)) {
            // TODO: abort
        }

        tray.set_status(IndicatorStatus.ACTIVE);
        tray.set_label("No signal", "rssimon");

        var menu = new Gtk.Menu();

        var item1 = new Gtk.MenuItem.with_label("Open details");
        item1.activate.connect(() => {
            Posix.system(this.get_details_command());
        });
        item1.show();
        menu.append(item1);

        var item2 = new Gtk.MenuItem.with_label("Exit");
        item2.show();
        item2.activate.connect(() => {
            this.destroy();
        });
        menu.append(item2);

        tray.set_menu(menu);

        tray.set_secondary_activate_target(item1);
    }

    public void run()
    {
        GLib.Timeout.add(500, () => {
            this.check_rssi();
            return true; // continue
        });

        Gtk.main();
    }

    private void check_rssi()
    {
        var rssi_url = this.get_rssi_url();

        var session = new Soup.Session();
        var message = new Soup.Message("GET", rssi_url);

        session.send_message(message);

        /*
        message.response_headers.foreach((name, val) => {
            Posix.stdout.printf("%s = %s\n", name, val);
        });
        */

        if (message.status_code == 200) {
            rssi = int.parse((string)message.response_body.data);  // TODO: error checking
        } else {
            rssi = -2;
        }

        update_rssi_label();
    }

    /**
     * Updates the tray icon according to this.rssi.
     **/
    private void update_rssi_label()
    {
        if (rssi == -2) {
            tray.set_label("No data", "rssimon");
            tray.set_icon("gsm-3g-none");
        }

        else if (rssi == -1) {
            tray.set_label("No signal", "rssimon");
            tray.set_icon("gsm-3g-none");
        }

        else {
            int dbm = -113 + rssi * 2;
            string label = "%d dBm (%d)".printf(dbm, rssi);
            tray.set_label(label, "rssimon");

            if (rssi < 4) {
                tray.set_icon("gsm-3g-low");
            }

            else if (rssi < 7) {
                tray.set_icon("gsm-3g-medium");
            }

            else if (rssi < 9) {
                tray.set_icon("gsm-3g-high");
            }

            else {
                tray.set_icon("gsm-3g-full");
            }
        }
    }

    /**
     * Returns the URL to fetch RSSI value from.
     *
     * Read it anew to avoid restarting the application after changing
     * the settings.
     *
     * @return string
     **/
    private string get_rssi_url()
    {
        var settings = new GLib.Settings("net.umonkey.rssimon");
        var url = settings.get_string("rssi-url");
        // stdout.printf("url = %s\n", url);
        return url;
    }

    /**
     * Returns the command to open detailed 3G status.
     *
     * Read it anew to avoid restarting the application after changing
     * the settings.
     *
     * @return string
     **/
    private string get_details_command()
    {
        var settings = new GLib.Settings("net.umonkey.rssimon");
        var command = settings.get_string("details-command");
        stdout.printf("command = %s\n", command);
        return command;
    }

    public static int main(string[] args)
    {
        Gtk.init(ref args);

        var app = new Application();
        app.run();

        return 0;
    }
}

// vim: set ts=4 sts=4 sw=4 et:
