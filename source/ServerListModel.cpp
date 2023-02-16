#include "ServerListModel.h"

ServerListModel::ServerListModel(QObject *parent) :
    QAbstractListModel(parent)
{
    m_servers = {
        {
            .name ="СПМ-1",
            .address="spm1.sreda.1440.space",
            .author="2"
        },
        {
            .name ="СПМ-1",
            .address="192.168.1.42",
            .author="J.Tuesday"
        },
        {
            .name ="СПМ-1",
            .address="spm1.sreda.1440.space",
            .author="J.Friday"
        }
    };
}

int ServerListModel::rowCount(const QModelIndex &parent) const
{
    return static_cast<int>(m_servers.size());
}

QVariant ServerListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    switch (role) {
    case NameRole:
        return m_servers.at(index.row()).name;
    case AddressRole:
        return m_servers.at(index.row()).address;
    case AuthorRole:
        return m_servers.at(index.row()).author;
    default:
        return QVariant();
    }
}

QHash<int, QByteArray> ServerListModel::roleNames() const
{
    QHash<int, QByteArray> roles = QAbstractListModel::roleNames();
    roles[NameRole]     = "name";
    roles[AddressRole]  = "address";
    roles[AuthorRole]   = "author";

    return roles;
}

QVariantMap ServerListModel::get(int row) const
{
    QHash<int, QByteArray> names = roleNames();
    QHashIterator<int, QByteArray> i(names);
    QVariantMap res;
    while (i.hasNext()) {
        i.next();
        QModelIndex idx = index(row, 0);
        QVariant data = idx.data(i.key());
        res[i.value()] = data;
    }
    return res;
}

void ServerListModel::addServer()
{
    emit beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_servers.push_back(
        {
         .name ="СПМ-1",
         .address="spm1.sreda.1440.space",
         .author="J.Friday"
        }
        );
    emit endInsertRows();
}
