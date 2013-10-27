# Selfie

Visual UI regression tests using PhantomJS, Poltergeist and Imagemagick for Capybara.

## To get started

For rails it's easy! Just add ``selfie`` to your ``Gemfile``

```
gem 'selfie'
```

Then create an integration test and include the `Selfie::DSL` and use `snap!` to capture a screenshot.

```
class CompletePurchaseTest < ActiveSupport::TestCase
  include Capybara::DSL
  include Selfie::DSL

  test "should do a complete purchase" do
    visit '/'
    assert has_content? 'Welcome to Shopping!'

    snap! 'home'

    # do more stuff here.

    make_report
    open_report
  end
end
```
### Creating reference image sets

Easy huh, except there is at this moment nothing to diff with. You need to run
the script once to create your reference images.

Selfie saves the images of the current run into `tmp/snap/current`. You can simply copy
that directory to create your reference images. It will look for the reference images in th `test/assets` directory. The name of the directory is the underscored variant with ``Test`` removed so in this case ``complete_purchase``

```
cp -R tmp/snap/current test/assets/complete_purchase
```


## Being forgiving

Sometimes you don't want a single pixel to fail your test. For instance, when you work
with generated dates. You can provide a threshold that allows for changes:

```
 snap! 'home', threshold: 0.01
```

You can see the threshold next to the image result in the make report.

## Capturing page on failed asserts

If you want to capture an image on a failed assert you can use the following 'freedom-patch' to override `assert`.

Like this:

```
class PurchaseTest < ActiveSupport::TestCase
  def assert(*args)
    passed = super(*args)
    ensure
    snap 'ERROR!' unless passed
  end
end
```

## Being async

`snap!` doesn't wait for a page load, it just snaps te current page. Normally, you might want to use one of the Capybara ``finders``, such as

```
assert has_content? 'Welcome to Shopping!'
```
to verify that specific page has loaded before you snap a shot!

## Under the hood

It basically relies on a couple of components. PhantomJS, and ImageMagick. It uses PhantomJS's, `save_screenshot` method to capture a screenshot. And ImageMagic's ``compare`` and ``convert`` to make a diff and measure the difference.

## Contribute!

Awesome please help me out! This is cool, but it can be much cooler, friendlier. More awesome. A couple of things on my wishlist!

- A assert `snap_and_compare! 'home', threshold: 0.05`
- snap! with a given element
- Add some tests if you like

