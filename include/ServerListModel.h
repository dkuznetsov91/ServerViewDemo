#pragma once

#include <qqmlregistration.h>
#include <QAbstractListModel>

struct ServerInfo
{
    QString name;
    QString address;
    QString author;
};

class ServerListModel : public QAbstractListModel {
    Q_OBJECT
    QML_ELEMENT
public:
    enum Roles {
        NameRole = Qt::UserRole + 1,
        AddressRole,
        AuthorRole
    };

    ServerListModel(QObject* parent = nullptr);

    virtual int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    virtual QVariant data(const QModelIndex& index, int role) const override;
    virtual QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void addServer();

private:
    std::vector<ServerInfo> m_servers;
};
