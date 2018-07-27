package no.nav.dagpenger.streams

import org.junit.Assert.assertNotNull
import org.junit.Test

class SchemaTest {
    @Test
    fun testAppHasAGreeting() {
        val classUnderTest = Topics
        assertNotNull("app should have a greeting", classUnderTest)
    }
}
