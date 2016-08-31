// Test new moltin
var options = {
    clientId: '',
    clientSecret: '',
    url: 'api.molt.in',
    port: '80',
    protocol: 'http',
    version: 'v2',
    debug: false
}


// Testing individual functions return the correct data
describe('Helper Unit Tests', function() {

    beforeEach(function() {
        this.helper = new Helper();
    });

    // Test merge function
    it("merges objects correctly together", function() {
        var obj1 = {
            a: 1,
            b: 2,
            c: 3
        }
        var obj2 = {
            a: "a",
            d: 4
        }
        var obj3 = {
            a: "a",
            b: 2,
            c: 3,
            d: 4
        }
        expect(this.helper.Merge(obj1, obj2)).toEqual(obj3);
    });

    // Test Serialize function
    it("serializes an object correctly", function() {
        var obj = {
            a: 1,
            b: 2
        }
        var prefix = "?";
        var serializedString = "%3F%5Ba%5D=1&%3F%5Bb%5D=2";
        expect(this.helper.Serialize(obj, prefix)).toEqual(serializedString);
    });

    // Test inArray function
    it("runs inarray correctly", function() {
        var arr = ["monkey", "balls"];
        expect(this.helper.InArray("balls", arr)).toBe(true);
        expect(this.helper.InArray("sick", arr)).toBe(false);
    });

});


describe('Storage Tests', function() {

    beforeEach(function() {
        this.storage = new Storage();
    });

    // Test Storage
    it("should set get and delete storage correctly", function() {
        var key = "monkey";
        var value = "balls";
        var days = 1;

        // Set and get
        this.storage.set(key, value, days);
        expect(this.storage.get(key)).toMatch(value);

        // Delete and get
        this.storage.remove(key);
        expect(this.storage.get(key)).toBe(null);

    });

    describe('Moltin Tests', function() {
        // Test override object
        it("has merged options and overrides correctly", function() {
            expect(this.moltin.options.clientId).toMatch(options.clientId);
            expect(this.moltin.options.clientSecret).toMatch(options.clientSecret);
            expect(this.moltin.options.url).toMatch(options.url);
            expect(this.moltin.options.port).toMatch(options.port);
            expect(this.moltin.options.protocol).toMatch(options.protocol);
            expect(this.moltin.options.version).toMatch(options.version);
            expect(this.moltin.options.debug).toEqual(options.debug);
        });
    });
});
