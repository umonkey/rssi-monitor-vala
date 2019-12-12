/**
 * Inspiration: http://bazaar.launchpad.net/~indicator-applet-developers/libappindicator/trunk.15.10/view/head:/bindings/vala/examples/indicator-example.vala
 **/

using Gtk;
using AppIndicator;
using Posix;
using Soup;

const string details_command = "x-www-browser http://traffic.umonkey.net/modem.php";

const string rssi_url = "http://traffic.umonkey.net/rssi.php";

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
        tray = new Indicator(this.title, "indicator-messages", IndicatorCategory.APPLICATION_STATUS);

        if (!(tray is Indicator)) {
            // TODO: abort
        }

        tray.set_status(IndicatorStatus.ACTIVE);
        tray.set_attention_icon("indicator-messages-new");

        var menu = new Gtk.Menu();

        var item1 = new Gtk.MenuItem.with_label("Open details");
        item1.activate.connect(() => {
            Posix.system(details_command);
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
        // this.show_all();

        this.update_rssi();

        Gtk.main();
    }

    private void update_rssi()
    {
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

        Posix.stdout.printf("RSSI = %d\n", rssi);
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
