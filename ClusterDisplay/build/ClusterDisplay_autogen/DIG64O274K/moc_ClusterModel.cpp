/****************************************************************************
** Meta object code from reading C++ file 'ClusterModel.hpp'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.4.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../inc/ClusterModel.hpp"
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'ClusterModel.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.4.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
namespace {
struct qt_meta_stringdata_ClusterModel_t {
    uint offsetsAndSizes[50];
    char stringdata0[13];
    char stringdata1[13];
    char stringdata2[1];
    char stringdata3[6];
    char stringdata4[15];
    char stringdata5[16];
    char stringdata6[16];
    char stringdata7[19];
    char stringdata8[19];
    char stringdata9[19];
    char stringdata10[19];
    char stringdata11[17];
    char stringdata12[25];
    char stringdata13[15];
    char stringdata14[19];
    char stringdata15[6];
    char stringdata16[8];
    char stringdata17[9];
    char stringdata18[9];
    char stringdata19[12];
    char stringdata20[12];
    char stringdata21[12];
    char stringdata22[12];
    char stringdata23[10];
    char stringdata24[18];
};
#define QT_MOC_LITERAL(ofs, len) \
    uint(sizeof(qt_meta_stringdata_ClusterModel_t::offsetsAndSizes) + ofs), len 
Q_CONSTINIT static const qt_meta_stringdata_ClusterModel_t qt_meta_stringdata_ClusterModel = {
    {
        QT_MOC_LITERAL(0, 12),  // "ClusterModel"
        QT_MOC_LITERAL(13, 12),  // "speedChanged"
        QT_MOC_LITERAL(26, 0),  // ""
        QT_MOC_LITERAL(27, 5),  // "value"
        QT_MOC_LITERAL(33, 14),  // "batteryChanged"
        QT_MOC_LITERAL(48, 15),  // "chargingChanged"
        QT_MOC_LITERAL(64, 15),  // "odometerChanged"
        QT_MOC_LITERAL(80, 18),  // "drivingModeChanged"
        QT_MOC_LITERAL(99, 18),  // "currentTimeChanged"
        QT_MOC_LITERAL(118, 18),  // "currentDateChanged"
        QT_MOC_LITERAL(137, 18),  // "objectAlertChanged"
        QT_MOC_LITERAL(156, 16),  // "laneAlertChanged"
        QT_MOC_LITERAL(173, 24),  // "laneDeviationSideChanged"
        QT_MOC_LITERAL(198, 14),  // "updateDateTime"
        QT_MOC_LITERAL(213, 18),  // "simulateDataUpdate"
        QT_MOC_LITERAL(232, 5),  // "speed"
        QT_MOC_LITERAL(238, 7),  // "battery"
        QT_MOC_LITERAL(246, 8),  // "charging"
        QT_MOC_LITERAL(255, 8),  // "odometer"
        QT_MOC_LITERAL(264, 11),  // "drivingMode"
        QT_MOC_LITERAL(276, 11),  // "currentTime"
        QT_MOC_LITERAL(288, 11),  // "currentDate"
        QT_MOC_LITERAL(300, 11),  // "objectAlert"
        QT_MOC_LITERAL(312, 9),  // "laneAlert"
        QT_MOC_LITERAL(322, 17)   // "laneDeviationSide"
    },
    "ClusterModel",
    "speedChanged",
    "",
    "value",
    "batteryChanged",
    "chargingChanged",
    "odometerChanged",
    "drivingModeChanged",
    "currentTimeChanged",
    "currentDateChanged",
    "objectAlertChanged",
    "laneAlertChanged",
    "laneDeviationSideChanged",
    "updateDateTime",
    "simulateDataUpdate",
    "speed",
    "battery",
    "charging",
    "odometer",
    "drivingMode",
    "currentTime",
    "currentDate",
    "objectAlert",
    "laneAlert",
    "laneDeviationSide"
};
#undef QT_MOC_LITERAL
} // unnamed namespace

Q_CONSTINIT static const uint qt_meta_data_ClusterModel[] = {

 // content:
      10,       // revision
       0,       // classname
       0,    0, // classinfo
      12,   14, // methods
      10,  118, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
      10,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    1,   86,    2, 0x06,   11 /* Public */,
       4,    1,   89,    2, 0x06,   13 /* Public */,
       5,    1,   92,    2, 0x06,   15 /* Public */,
       6,    1,   95,    2, 0x06,   17 /* Public */,
       7,    1,   98,    2, 0x06,   19 /* Public */,
       8,    1,  101,    2, 0x06,   21 /* Public */,
       9,    1,  104,    2, 0x06,   23 /* Public */,
      10,    1,  107,    2, 0x06,   25 /* Public */,
      11,    1,  110,    2, 0x06,   27 /* Public */,
      12,    1,  113,    2, 0x06,   29 /* Public */,

 // slots: name, argc, parameters, tag, flags, initial metatype offsets
      13,    0,  116,    2, 0x08,   31 /* Private */,
      14,    0,  117,    2, 0x08,   32 /* Private */,

 // signals: parameters
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::Bool,    3,
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void, QMetaType::Bool,    3,
    QMetaType::Void, QMetaType::Bool,    3,
    QMetaType::Void, QMetaType::QString,    3,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,

 // properties: name, type, flags
      15, QMetaType::Int, 0x00015103, uint(0), 0,
      16, QMetaType::Int, 0x00015103, uint(1), 0,
      17, QMetaType::Bool, 0x00015103, uint(2), 0,
      18, QMetaType::Int, 0x00015103, uint(3), 0,
      19, QMetaType::QString, 0x00015103, uint(4), 0,
      20, QMetaType::QString, 0x00015001, uint(5), 0,
      21, QMetaType::QString, 0x00015001, uint(6), 0,
      22, QMetaType::Bool, 0x00015103, uint(7), 0,
      23, QMetaType::Bool, 0x00015103, uint(8), 0,
      24, QMetaType::QString, 0x00015103, uint(9), 0,

       0        // eod
};

Q_CONSTINIT const QMetaObject ClusterModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_ClusterModel.offsetsAndSizes,
    qt_meta_data_ClusterModel,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_stringdata_ClusterModel_t,
        // property 'speed'
        QtPrivate::TypeAndForceComplete<int, std::true_type>,
        // property 'battery'
        QtPrivate::TypeAndForceComplete<int, std::true_type>,
        // property 'charging'
        QtPrivate::TypeAndForceComplete<bool, std::true_type>,
        // property 'odometer'
        QtPrivate::TypeAndForceComplete<int, std::true_type>,
        // property 'drivingMode'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // property 'currentTime'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // property 'currentDate'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // property 'objectAlert'
        QtPrivate::TypeAndForceComplete<bool, std::true_type>,
        // property 'laneAlert'
        QtPrivate::TypeAndForceComplete<bool, std::true_type>,
        // property 'laneDeviationSide'
        QtPrivate::TypeAndForceComplete<QString, std::true_type>,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<ClusterModel, std::true_type>,
        // method 'speedChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'batteryChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'chargingChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'odometerChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'drivingModeChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'currentTimeChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'currentDateChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'objectAlertChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'laneAlertChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'laneDeviationSideChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'updateDateTime'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'simulateDataUpdate'
        QtPrivate::TypeAndForceComplete<void, std::false_type>
    >,
    nullptr
} };

void ClusterModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<ClusterModel *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->speedChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 1: _t->batteryChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 2: _t->chargingChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 3: _t->odometerChanged((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 4: _t->drivingModeChanged((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 5: _t->currentTimeChanged((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 6: _t->currentDateChanged((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 7: _t->objectAlertChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 8: _t->laneAlertChanged((*reinterpret_cast< std::add_pointer_t<bool>>(_a[1]))); break;
        case 9: _t->laneDeviationSideChanged((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 10: _t->updateDateTime(); break;
        case 11: _t->simulateDataUpdate(); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (ClusterModel::*)(int );
            if (_t _q_method = &ClusterModel::speedChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (ClusterModel::*)(int );
            if (_t _q_method = &ClusterModel::batteryChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (ClusterModel::*)(bool );
            if (_t _q_method = &ClusterModel::chargingChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (ClusterModel::*)(int );
            if (_t _q_method = &ClusterModel::odometerChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 3;
                return;
            }
        }
        {
            using _t = void (ClusterModel::*)(const QString & );
            if (_t _q_method = &ClusterModel::drivingModeChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 4;
                return;
            }
        }
        {
            using _t = void (ClusterModel::*)(const QString & );
            if (_t _q_method = &ClusterModel::currentTimeChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 5;
                return;
            }
        }
        {
            using _t = void (ClusterModel::*)(const QString & );
            if (_t _q_method = &ClusterModel::currentDateChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 6;
                return;
            }
        }
        {
            using _t = void (ClusterModel::*)(bool );
            if (_t _q_method = &ClusterModel::objectAlertChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 7;
                return;
            }
        }
        {
            using _t = void (ClusterModel::*)(bool );
            if (_t _q_method = &ClusterModel::laneAlertChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 8;
                return;
            }
        }
        {
            using _t = void (ClusterModel::*)(const QString & );
            if (_t _q_method = &ClusterModel::laneDeviationSideChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 9;
                return;
            }
        }
    }else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<ClusterModel *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< int*>(_v) = _t->speed(); break;
        case 1: *reinterpret_cast< int*>(_v) = _t->battery(); break;
        case 2: *reinterpret_cast< bool*>(_v) = _t->charging(); break;
        case 3: *reinterpret_cast< int*>(_v) = _t->odometer(); break;
        case 4: *reinterpret_cast< QString*>(_v) = _t->drivingMode(); break;
        case 5: *reinterpret_cast< QString*>(_v) = _t->currentTime(); break;
        case 6: *reinterpret_cast< QString*>(_v) = _t->currentDate(); break;
        case 7: *reinterpret_cast< bool*>(_v) = _t->objectAlert(); break;
        case 8: *reinterpret_cast< bool*>(_v) = _t->laneAlert(); break;
        case 9: *reinterpret_cast< QString*>(_v) = _t->laneDeviationSide(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<ClusterModel *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setSpeed(*reinterpret_cast< int*>(_v)); break;
        case 1: _t->setBattery(*reinterpret_cast< int*>(_v)); break;
        case 2: _t->setCharging(*reinterpret_cast< bool*>(_v)); break;
        case 3: _t->setOdometer(*reinterpret_cast< int*>(_v)); break;
        case 4: _t->setDrivingMode(*reinterpret_cast< QString*>(_v)); break;
        case 7: _t->setObjectAlert(*reinterpret_cast< bool*>(_v)); break;
        case 8: _t->setLaneAlert(*reinterpret_cast< bool*>(_v)); break;
        case 9: _t->setLaneDeviationSide(*reinterpret_cast< QString*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    } else if (_c == QMetaObject::BindableProperty) {
    }
}

const QMetaObject *ClusterModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ClusterModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ClusterModel.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int ClusterModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 12)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 12;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 12)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 12;
    }else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    }
    return _id;
}

// SIGNAL 0
void ClusterModel::speedChanged(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void ClusterModel::batteryChanged(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void ClusterModel::chargingChanged(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void ClusterModel::odometerChanged(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

// SIGNAL 4
void ClusterModel::drivingModeChanged(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 4, _a);
}

// SIGNAL 5
void ClusterModel::currentTimeChanged(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}

// SIGNAL 6
void ClusterModel::currentDateChanged(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 6, _a);
}

// SIGNAL 7
void ClusterModel::objectAlertChanged(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 7, _a);
}

// SIGNAL 8
void ClusterModel::laneAlertChanged(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 8, _a);
}

// SIGNAL 9
void ClusterModel::laneDeviationSideChanged(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 9, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
