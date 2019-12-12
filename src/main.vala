/**
 * Inspiration: http://bazaar.launchpad.net/~indicator-applet-developers/libappindicator/trunk.15.10/view/head:/bindings/vala/examples/indicator-example.vala
 **/

using Gtk;
using AppIndicator;

public class Application : Window
{
    private Indicator tray;

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
            // TODO: run the browser.
            tray.set_status(IndicatorStatus.ATTENTION);
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

        Gtk.main();
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
