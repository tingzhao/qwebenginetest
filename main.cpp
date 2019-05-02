#include <QWebEngineView>

#include <QtWebEngine/qtwebengineglobal.h>
#include <QApplication>

//Adopted from https://doc.qt.io/qt-5/qtwebengine-webenginewidgets-minimal-example.html

QUrl commandLineUrlArgument()
{
    const QStringList args = QCoreApplication::arguments();
    for (const QString &arg : args.mid(1)) {
        if (!arg.startsWith(QLatin1Char('-')))
            return QUrl::fromUserInput(arg);
    }
    return QUrl(QStringLiteral("https://www.google.com"));
}

int main(int argc, char* argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    QWebEngineView view;
    view.setUrl(commandLineUrlArgument());
    view.resize(1024, 750);
    view.show();

    return app.exec();
}
