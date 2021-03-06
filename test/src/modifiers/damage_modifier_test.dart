import 'package:gurps_dart/gurps_dart.dart';
import 'package:gurps_dice/gurps_dice.dart';
import 'package:gurps_rpm_model/gurps_rpm_model.dart';

import "package:test/test.dart";

void main() {
  group('Damage:', () {
    const d1 = DieRoll(dice: 1, adds: 0);
    const d1p1 = DieRoll(dice: 1, adds: 1);
    const d1p2 = DieRoll(dice: 1, adds: 2);
    const d2m1 = DieRoll(dice: 2, adds: -1);
    const d2 = DieRoll(dice: 2, adds: 0);
    const d2p1 = DieRoll(dice: 2, adds: 1);
    const d2p2 = DieRoll(dice: 2, adds: 2);
    const d3m1 = DieRoll(dice: 3, adds: -1);
    const d3 = DieRoll(dice: 3, adds: 0);
    const d3p2 = DieRoll(dice: 3, adds: 2);
    const d4m1 = DieRoll(dice: 4, adds: -1);
    const d4 = DieRoll(dice: 4, adds: 0);
    const d4p2 = DieRoll(dice: 4, adds: 2);
    const d5 = DieRoll(dice: 5, adds: 0);
    const d5p1 = DieRoll(dice: 5, adds: 1);
    const d5p2 = DieRoll(dice: 5, adds: 2);
    const d6 = DieRoll(dice: 6, adds: 0);
    const d7m1 = DieRoll(dice: 7, adds: -1);
    const d7p2 = DieRoll(dice: 7, adds: 2);
    const d8p1 = DieRoll(dice: 8, adds: 1);

    Damage m;

    setUp(() async {
      m = Damage();
    });

    test('has initial state', () {
      expect(m.dice, equals(d1));
      expect(m.name, equals('Damage'));
      expect(m.energyCost, equals(0));

      expect(m.type, equals((DamageType.crushing)));
      expect(m.direct, equals((true)));
      expect(m.explosive, equals((false)));
    });

    test('has type', () {
      expect(m.copyWith(type: DamageType.cutting).type,
          equals(DamageType.cutting));
    });

    test("has direct", () {
      expect(m.copyWith(direct: false).direct, equals(false));
    });

    test('has explosive', () {
      // setting explosive to true when direct is also true has no effect
      expect(m.copyWith(explosive: true).explosive, equals(false));

      expect(
          m.copyWith(direct: false, explosive: true).explosive, equals(true));
    });

    test('has damage dice', () {
      expect(m.damageDice, equals(DieRoll.fromString('1d')));
      expect(m.copyWith(dice: d1p1).damageDice, equals(d1p1));
      expect(m.copyWith(dice: d1p2).damageDice, equals(d1p2));
      expect(m.copyWith(dice: d2m1).damageDice, equals(d2m1));
    });

    test('has increment effect', () {
      expect(m.incrementEffect(3).damageDice, equals(d2m1));
      expect(m.incrementEffect(7).damageDice, equals(d3m1));
      expect(m.incrementEffect(3).incrementEffect(7).damageDice, equals(d3p2));
    });

    group('damage for burn, cr, pi, tox', () {
      const types = [
        DamageType.burning,
        DamageType.crushing,
        DamageType.piercing,
        DamageType.toxic
      ];

      test('has energy costs and damage', () {
        for (var type in types) {
          var t = m.copyWith(type: type);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d1));

          expect(t.copyWith(dice: d1p1).energyCost, equals(1));
          expect(t.copyWith(dice: d1p1).damageDice, equals(d1p1));

          expect(t.copyWith(dice: d1p2).energyCost, equals(2));
          expect(t.copyWith(dice: d1p2).damageDice, equals(d1p2));

          expect(t.copyWith(dice: d2m1).energyCost, equals(3));
          expect(t.copyWith(dice: d2m1).damageDice, equals(d2m1));

          expect(t.copyWith(dice: d2).energyCost, equals(4));
          expect(t.copyWith(dice: d2).damageDice, equals(d2));

          expect(t.copyWith(dice: d2p1).energyCost, equals(5));
          expect(t.copyWith(dice: d2p1).damageDice, equals(d2p1));

          expect(t.copyWith(dice: d2p2).energyCost, equals(6));
          expect(t.copyWith(dice: d2p2).damageDice, equals(d2p2));

          expect(t.copyWith(dice: d3m1).energyCost, equals(7));
          expect(t.copyWith(dice: d3m1).damageDice, equals(d3m1));
        }
      });

      test('triple damage for indirect damage', () {
        for (var type in types) {
          var t = m.copyWith(type: type, direct: false);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(DieRoll(dice: 3, adds: 0)));

          expect(t.copyWith(dice: d1p1).energyCost, equals(1));
          expect(t.copyWith(dice: d1p1).damageDice, equals(d4m1));

          expect(t.copyWith(dice: d1p2).energyCost, equals(2));
          expect(t.copyWith(dice: d1p2).damageDice, equals(d4p2));

          expect(t.copyWith(dice: d2m1).energyCost, equals(3));
          expect(t.copyWith(dice: d2m1).damageDice, equals(d5p1));

          expect(t.copyWith(dice: d2).energyCost, equals(4));
          expect(t.copyWith(dice: d2).damageDice, equals(d6));

          expect(t.copyWith(dice: d2p1).energyCost, equals(5));
          expect(t.copyWith(dice: d2p1).damageDice, equals(d7m1));

          expect(t.copyWith(dice: d2p2).energyCost, equals(6));
          expect(t.copyWith(dice: d2p2).damageDice, equals(d7p2));

          expect(t.copyWith(dice: d3m1).energyCost, equals(7));
          expect(t.copyWith(dice: d3m1).damageDice, equals(d8p1));
        }
      });

      test('double damage for indirect, explosive damage', () {
        for (var type in types) {
          var t = m.copyWith(type: type, direct: false, explosive: true);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d2));

          expect(t.copyWith(dice: d1p1).energyCost, equals(1));
          expect(t.copyWith(dice: d1p1).damageDice, equals(d2p2));

          expect(t.copyWith(dice: d1p2).energyCost, equals(2));
          expect(t.copyWith(dice: d1p2).damageDice, equals(d3));

          expect(t.copyWith(dice: d2m1).energyCost, equals(3));
          expect(t.copyWith(dice: d2m1).damageDice, equals(d3p2));

          expect(t.copyWith(dice: d2).energyCost, equals(4));
          expect(t.copyWith(dice: d2).damageDice, equals(d4));

          expect(t.copyWith(dice: d2p1).energyCost, equals(5));
          expect(t.copyWith(dice: d2p1).damageDice, equals(d4p2));

          expect(t.copyWith(dice: d2p2).energyCost, equals(6));
          expect(t.copyWith(dice: d2p2).damageDice, equals(d5));

          expect(t.copyWith(dice: d3m1).energyCost, equals(7));
          expect(t.copyWith(dice: d3m1).damageDice, equals(d5p2));
        }
      });
    });

    group('damage for pi-', () {
      Damage t;

      setUp(() async {
        t = m.copyWith(type: DamageType.smallPiercing);
      });

      test('has energy costs', () {
        expect(t.energyCost, equals(0));
        expect(t.damageDice, equals(d1));

        expect(t.copyWith(dice: d1p1).energyCost, equals(1));
        expect(t.copyWith(dice: d1p1).damageDice, equals(d1p1));

        expect(t.copyWith(dice: d1p2).energyCost, equals(1));
        expect(t.copyWith(dice: d1p2).damageDice, equals(d1p2));

        expect(t.copyWith(dice: d2m1).energyCost, equals(2));
        expect(t.copyWith(dice: d2m1).damageDice, equals(d2m1));

        expect(t.copyWith(dice: d2).energyCost, equals(2));
        expect(t.copyWith(dice: d2).damageDice, equals(d2));

        expect(t.copyWith(dice: d2p1).energyCost, equals(3));
        expect(t.copyWith(dice: d2p1).damageDice, equals(d2p1));

        expect(t.copyWith(dice: d2p2).energyCost, equals(3));
        expect(t.copyWith(dice: d2p2).damageDice, equals(d2p2));

        expect(t.copyWith(dice: d3m1).energyCost, equals(4));
        expect(t.copyWith(dice: d3m1).damageDice, equals(d3m1));
      });

      test('triple damage for indirect damage', () {
        t = t.copyWith(direct: false);

        expect(t.energyCost, equals(0));
        expect(t.damageDice, equals(DieRoll(dice: 3, adds: 0)));

        expect(t.copyWith(dice: d1p1).energyCost, equals(1));
        expect(t.copyWith(dice: d1p1).damageDice, equals(d4m1));

        expect(t.copyWith(dice: d1p2).energyCost, equals(1));
        expect(t.copyWith(dice: d1p2).damageDice, equals(d4p2));

        expect(t.copyWith(dice: d2m1).energyCost, equals(2));
        expect(t.copyWith(dice: d2m1).damageDice, equals(d5p1));

        expect(t.copyWith(dice: d2).energyCost, equals(2));
        expect(t.copyWith(dice: d2).damageDice, equals(d6));

        expect(t.copyWith(dice: d2p1).energyCost, equals(3));
        expect(t.copyWith(dice: d2p1).damageDice, equals(d7m1));

        expect(t.copyWith(dice: d2p2).energyCost, equals(3));
        expect(t.copyWith(dice: d2p2).damageDice, equals(d7p2));

        expect(t.copyWith(dice: d3m1).energyCost, equals(4));
        expect(t.copyWith(dice: d3m1).damageDice, equals(d8p1));
      });

      test('double damage for indirect, explosive damage', () {
        t = t.copyWith(direct: false, explosive: true);

        expect(t.energyCost, equals(0));
        expect(t.damageDice, equals(d2));

        expect(t.copyWith(dice: d1p1).energyCost, equals(1));
        expect(t.copyWith(dice: d1p1).damageDice, equals(d2p2));

        expect(t.copyWith(dice: d1p2).energyCost, equals(1));
        expect(t.copyWith(dice: d1p2).damageDice, equals(d3));

        expect(t.copyWith(dice: d2m1).energyCost, equals(2));
        expect(t.copyWith(dice: d2m1).damageDice, equals(d3p2));

        expect(t.copyWith(dice: d2).energyCost, equals(2));
        expect(t.copyWith(dice: d2).damageDice, equals(d4));

        expect(t.copyWith(dice: d2p1).energyCost, equals(3));
        expect(t.copyWith(dice: d2p1).damageDice, equals(d4p2));

        expect(t.copyWith(dice: d2p2).energyCost, equals(3));
        expect(t.copyWith(dice: d2p2).damageDice, equals(d5));

        expect(t.copyWith(dice: d3m1).energyCost, equals(4));
        expect(t.copyWith(dice: d3m1).damageDice, equals(d5p2));
      });
    });

    group('damage for cut, pi+', () {
      const types = [DamageType.cutting, DamageType.largePiercing];

      test('has energy costs', () {
        for (var type in types) {
          var t = m.copyWith(type: type);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d1));

          expect(t.copyWith(dice: d1p1).energyCost, equals(2));
          expect(t.copyWith(dice: d1p1).damageDice, equals(d1p1));

          expect(t.copyWith(dice: d1p2).energyCost, equals(3));
          expect(t.copyWith(dice: d1p2).damageDice, equals(d1p2));

          expect(t.copyWith(dice: d2m1).energyCost, equals(5));
          expect(t.copyWith(dice: d2m1).damageDice, equals(d2m1));

          expect(t.copyWith(dice: d2).energyCost, equals(6));
          expect(t.copyWith(dice: d2).damageDice, equals(d2));

          expect(t.copyWith(dice: d2p1).energyCost, equals(8));
          expect(t.copyWith(dice: d2p1).damageDice, equals(d2p1));

          expect(t.copyWith(dice: d2p2).energyCost, equals(9));
          expect(t.copyWith(dice: d2p2).damageDice, equals(d2p2));

          expect(t.copyWith(dice: d3m1).energyCost, equals(11));
          expect(t.copyWith(dice: d3m1).damageDice, equals(d3m1));
        }
      });

      test('triple damage for indirect damage', () {
        for (var type in types) {
          var t = m.copyWith(type: type, direct: false);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(DieRoll(dice: 3, adds: 0)));

          expect(t.copyWith(dice: d1p1).energyCost, equals(2));
          expect(t.copyWith(dice: d1p1).damageDice, equals(d4m1));

          expect(t.copyWith(dice: d1p2).energyCost, equals(3));
          expect(t.copyWith(dice: d1p2).damageDice, equals(d4p2));

          expect(t.copyWith(dice: d2m1).energyCost, equals(5));
          expect(t.copyWith(dice: d2m1).damageDice, equals(d5p1));

          expect(t.copyWith(dice: d2).energyCost, equals(6));
          expect(t.copyWith(dice: d2).damageDice, equals(d6));

          expect(t.copyWith(dice: d2p1).energyCost, equals(8));
          expect(t.copyWith(dice: d2p1).damageDice, equals(d7m1));

          expect(t.copyWith(dice: d2p2).energyCost, equals(9));
          expect(t.copyWith(dice: d2p2).damageDice, equals(d7p2));

          expect(t.copyWith(dice: d3m1).energyCost, equals(11));
          expect(t.copyWith(dice: d3m1).damageDice, equals(d8p1));
        }
      });

      test('double damage for indirect, explosive damage', () {
        for (var type in types) {
          var t = m.copyWith(type: type, direct: false, explosive: true);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d2));

          expect(t.copyWith(dice: d1p1).energyCost, equals(2));
          expect(t.copyWith(dice: d1p1).damageDice, equals(d2p2));

          expect(t.copyWith(dice: d1p2).energyCost, equals(3));
          expect(t.copyWith(dice: d1p2).damageDice, equals(d3));

          expect(t.copyWith(dice: d2m1).energyCost, equals(5));
          expect(t.copyWith(dice: d2m1).damageDice, equals(d3p2));

          expect(t.copyWith(dice: d2).energyCost, equals(6));
          expect(t.copyWith(dice: d2).damageDice, equals(d4));

          expect(t.copyWith(dice: d2p1).energyCost, equals(8));
          expect(t.copyWith(dice: d2p1).damageDice, equals(d4p2));

          expect(t.copyWith(dice: d2p2).energyCost, equals(9));
          expect(t.copyWith(dice: d2p2).damageDice, equals(d5));

          expect(t.copyWith(dice: d3m1).energyCost, equals(11));
          expect(t.copyWith(dice: d3m1).damageDice, equals(d5p2));
        }
      });
    });

    group('damage for cor, fat, pi++, imp', () {
      const types = [
        DamageType.corrosive,
        DamageType.fatigue,
        DamageType.hugePiercing,
        DamageType.impaling
      ];

      test('has energy costs', () {
        for (var type in types) {
          var t = m.copyWith(type: type);
          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d1));

          expect(t.copyWith(dice: d1p1).energyCost, equals(2));
          expect(t.copyWith(dice: d1p1).damageDice, equals(d1p1));

          expect(t.copyWith(dice: d1p2).energyCost, equals(4));
          expect(t.copyWith(dice: d1p2).damageDice, equals(d1p2));

          expect(t.copyWith(dice: d2m1).energyCost, equals(6));
          expect(t.copyWith(dice: d2m1).damageDice, equals(d2m1));

          expect(t.copyWith(dice: d2).energyCost, equals(8));
          expect(t.copyWith(dice: d2).damageDice, equals(d2));

          expect(t.copyWith(dice: d2p1).energyCost, equals(10));
          expect(t.copyWith(dice: d2p1).damageDice, equals(d2p1));

          expect(t.copyWith(dice: d2p2).energyCost, equals(12));
          expect(t.copyWith(dice: d2p2).damageDice, equals(d2p2));

          expect(t.copyWith(dice: d3m1).energyCost, equals(14));
          expect(t.copyWith(dice: d3m1).damageDice, equals(d3m1));
        }
      });

      test('triple damage for indirect damage', () {
        for (var type in types) {
          var t = m.copyWith(type: type, direct: false);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(DieRoll(dice: 3, adds: 0)));

          expect(t.copyWith(dice: d1p1).energyCost, equals(2));
          expect(t.copyWith(dice: d1p1).damageDice, equals(d4m1));

          expect(t.copyWith(dice: d1p2).energyCost, equals(4));
          expect(t.copyWith(dice: d1p2).damageDice, equals(d4p2));

          expect(t.copyWith(dice: d2m1).energyCost, equals(6));
          expect(t.copyWith(dice: d2m1).damageDice, equals(d5p1));

          expect(t.copyWith(dice: d2).energyCost, equals(8));
          expect(t.copyWith(dice: d2).damageDice, equals(d6));

          expect(t.copyWith(dice: d2p1).energyCost, equals(10));
          expect(t.copyWith(dice: d2p1).damageDice, equals(d7m1));

          expect(t.copyWith(dice: d2p2).energyCost, equals(12));
          expect(t.copyWith(dice: d2p2).damageDice, equals(d7p2));

          expect(t.copyWith(dice: d3m1).energyCost, equals(14));
          expect(t.copyWith(dice: d3m1).damageDice, equals(d8p1));
        }
      });

      test('double damage for indirect, explosive damage', () {
        for (var type in types) {
          var t = m.copyWith(type: type, direct: false, explosive: true);

          expect(t.energyCost, equals(0));
          expect(t.damageDice, equals(d2));

          expect(t.copyWith(dice: d1p1).energyCost, equals(2));
          expect(t.copyWith(dice: d1p1).damageDice, equals(d2p2));

          expect(t.copyWith(dice: d1p2).energyCost, equals(4));
          expect(t.copyWith(dice: d1p2).damageDice, equals(d3));

          expect(t.copyWith(dice: d2m1).energyCost, equals(6));
          expect(t.copyWith(dice: d2m1).damageDice, equals(d3p2));

          expect(t.copyWith(dice: d2).energyCost, equals(8));
          expect(t.copyWith(dice: d2).damageDice, equals(d4));

          expect(t.copyWith(dice: d2p1).energyCost, equals(10));
          expect(t.copyWith(dice: d2p1).damageDice, equals(d4p2));

          expect(t.copyWith(dice: d2p2).energyCost, equals(12));
          expect(t.copyWith(dice: d2p2).damageDice, equals(d5));

          expect(t.copyWith(dice: d3m1).energyCost, equals(14));
          expect(t.copyWith(dice: d3m1).damageDice, equals(d5p2));
        }
      });
    });

    // Each +5% adds 1 SP if the base cost for Damage is 20 SP or less.
    test('should add 1 energy per 5 Percent of Enhancers', () {
      var t1 = m.copyWith(dice: (DieRoll(dice: 1, adds: 10)));
      expect(t1.energyCost, equals(10));

      t1 = t1.addModifier(TraitModifier(name: 'foo', percent: 1));
      expect(t1.energyCost, equals(11));
      t1 = t1.addModifier(TraitModifier(name: 'bar', percent: 4));
      expect(t1.energyCost, equals(11));
      t1 = t1.addModifier(TraitModifier(name: 'baz', percent: 2));
      expect(t1.energyCost, equals(12));
      t1 = t1.addModifier(TraitModifier(name: 'qux', percent: 8));
      expect(t1.energyCost, equals(13));

      var t2 = m.copyWith(dice: (DieRoll(dice: 1, adds: 20)));
      expect(t2.energyCost, equals(20));

      t2 = t2.addModifier(TraitModifier(name: 'foo', percent: 1));
      expect(t2.energyCost, equals(21));
      t2 = t2.addModifier(TraitModifier(name: 'bar', percent: 4));
      expect(t2.energyCost, equals(21));
      t2 = t2.addModifier(TraitModifier(name: 'baz', percent: 2));
      expect(t2.energyCost, equals(22));
      t2 = t2.addModifier(TraitModifier(name: 'qux', percent: 8));
      expect(t2.energyCost, equals(23));
    });

    // If Damage costs 21 SP or more, apply the enhancement percentage to the
    // SP cost for Damage only (not to the cost of the whole spell); round up.
    test("should Add 1 energy cost Per 1 Percent", () {
      var t1 = m.copyWith(dice: (DieRoll(dice: 1, adds: 21)));
      expect(t1.energyCost, equals(21));

      t1 = t1.addModifier(TraitModifier(name: 'foo', percent: 1));
      expect(t1.energyCost, equals(22));
      t1 = t1.addModifier(TraitModifier(name: 'bar', percent: 4));
      expect(t1.energyCost, equals(26));
      t1 = t1.addModifier(TraitModifier(name: 'baz', percent: 2));
      expect(t1.energyCost, equals(28));
    });

    // Added limitations reduce this surcharge, but will never provide a net SP
    // discount.
    test("should Not Add 1 Point", () {
      var t1 = m.copyWith(dice: (DieRoll(dice: 1, adds: 10)));
      t1 = t1.addModifier(TraitModifier(name: 'foo', percent: 10));
      t1 = t1.addModifier(TraitModifier(name: 'bar', percent: -5));
      expect(t1.energyCost, equals(11));

      t1 = t1.copyWith(dice: (DieRoll(dice: 1, adds: 30)));
      expect(t1.energyCost, equals(35));

      t1 = t1.addModifier(TraitModifier(name: 'baz', percent: -10));
      expect(t1.energyCost, equals(31));

      t1 = m.copyWith(dice: (DieRoll(dice: 1, adds: 10)));
      expect(t1.energyCost, equals(10));
    });

    test('implements == and hashCode', () {
      expect(m, equals(Damage()));
      expect(
          m.hashCode, equals(Damage(dice: DieRoll(dice: 1, adds: 0)).hashCode));
      expect(m, isNot(equals(m.copyWith(dice: DieRoll(dice: 2, adds: 0)))));
      expect(m, isNot(equals(m.copyWith(direct: false))));
    });
  });
}
